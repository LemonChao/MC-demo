//
//  LCTabbarView.m
//  标签栏视图
//
//  Created by Lemon on 17/2/22.
//  Copyright © 2017年 HY. All rights reserved.
//

//
//  HYTabbarView.m
//  标签栏视图-多视图滑动点击切换
//
//  Created by Sekorm on 16/3/31.
//  Copyright © 2016年 HY. All rights reserved.
// 一个button就是一个item，伴随红线是view的一个属性

#import "LCTabbarView.h"
#import "LCNullView.h"

static CGFloat const topBarItemMargin = 15; ///标题之间的间距
static CGFloat const topBarHeight = 40; //顶部标签条的高度
@interface LCTabbarView ()<UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray * titles;
@property (nonatomic,weak) UIScrollView * tabbar;
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,assign) NSInteger  selectedIndex;
@property (nonatomic,assign) NSInteger  preSelectedIndex;
@property (nonatomic,assign) CGFloat  tabbarWidth; //顶部标签条的宽度
@property (nonatomic,strong) UIView *lineView;
@end
@implementation LCTabbarView

#pragma mark - ************************* 重写构造方法 *************************
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BGColor;
        _selectedIndex = 0;
        _preSelectedIndex = 0;
        _tabbarWidth = topBarItemMargin;
        [self setUpSubview];
        
    }
    return self;
}

#pragma mark - ************************* 懒加载 *************************

- (NSMutableArray *)titles{
    
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] init];
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.bounces = NO;
        _bgScrollView.pagingEnabled = YES;
        _bgScrollView.delegate = self;
        
    }
    return _bgScrollView;
}

#pragma mark -   ************************* UI处理 *************************
//添加子控件
- (void)setUpSubview{
    
    UIScrollView * tabbar = [[UIScrollView alloc]init];
    tabbar.backgroundColor = [UIColor whiteColor];
    [self addSubview:tabbar];
    self.tabbar = tabbar;
    tabbar.showsHorizontalScrollIndicator = NO;
    tabbar.showsVerticalScrollIndicator = NO;
    tabbar.bounces = NO;
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = MainColor;
    [self.tabbar addSubview:self.lineView];
    
    [self addSubview:self.bgScrollView];
    
    //添加监听
    [self addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionOld |NSKeyValueObservingOptionNew context:@"scrollToNextItem"];
}

//布局子控件
- (void)layoutSubviews{
    
    [super layoutSubviews];
    NSInteger count = self.titles.count;
    
    CGRect rect = self.bounds;
    self.tabbar.frame = CGRectMake(0, 0, rect.size.width, topBarHeight);
    self.tabbar.contentSize = CGSizeMake(_tabbarWidth, 0);
    self.bgScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.tabbar.frame), rect.size.width,(self.bounds.size.height - topBarHeight));
    self.bgScrollView.contentSize = CGSizeMake(HYScreenW*count, (self.bounds.size.height - topBarHeight));
    self.lineView.frame = CGRectMake(0, topBarHeight-2, HYScreenW/count, 2);
    [self.tabbar bringSubviewToFront:self.lineView];
    
    CGFloat btnH = topBarHeight;
    CGFloat btnX = topBarItemMargin;
    int i = 0;
    for (UIView *subView in self.tabbar.subviews) {
        
        if ([subView isKindOfClass:[UIButton class]]) {
            subView.frame = CGRectMake(btnX, 0, (rect.size.width-topBarItemMargin*(count+1))/count, btnH);
            btnX += subView.frame.size.width + topBarItemMargin;
            i++;
        }
        
    }
    
    [self itemSelectedIndex:0];
}

#pragma mark -   *************************  KVO监听方法 *************************

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == @"scrollToNextItem") {
        
        [self itemSelectedIndex:self.selectedIndex];

    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect rect = self.lineView.frame;
    rect.origin.x = scrollView.contentOffset.x/scrollView.contentSize.width*HYScreenW;
    self.lineView.frame = rect;
    
    CGFloat offset = (scrollView.contentOffset.x + HYScreenW * 0.5) / HYScreenW;
    NSInteger actualIndex = [[NSNumber numberWithFloat:offset] integerValue];
    if(self.selectedIndex != actualIndex){
        
        self.selectedIndex = actualIndex;
        
    }
    
}

#pragma mark - ************************* Private方法 *************************

- (void)itemSelectedIndex:(NSInteger)index{
    
    UIButton * preSelectedBtn = self.titles[_preSelectedIndex];
    preSelectedBtn.selected = NO;
    _selectedIndex = index;
    _preSelectedIndex = _selectedIndex;
    UIButton * selectedBtn = self.titles[index];
    selectedBtn.selected = YES;
    [UIView animateWithDuration:0.25 animations:^{
        preSelectedBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        selectedBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    }];
}

- (void)itemSelected:(UIButton *)btn{
    
    NSInteger index = [self.titles indexOfObject:btn];
    
    [self.bgScrollView setContentOffset:CGPointMake(index * self.bounds.size.width, 0) animated:YES];
}
#pragma mark - ************************* 对外接口 *************************

// 设置顶部标签按钮
- (void)setupBtn:(UIButton *)btn withTitle:(NSString *)title{
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn sizeToFit];
    _tabbarWidth += btn.frame.size.width + topBarItemMargin; //添加一个宽度增加一下
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:MainColor forState:UIControlStateSelected];
}


//外界传个控制器,添加一个栏目
- (void)addSubItemWithView:(UIView *)view title:(NSString *)title{
    
    LCNullView *nullView = [[LCNullView alloc] initWithFrame:view.frame imgString:@"offline_nodata" labTitleString:@"没有数据哦！"];
    
    [self.bgScrollView addSubview:nullView];
    [self.bgScrollView addSubview:view];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tabbar addSubview:btn];
    [self.titles addObject:btn];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self setupBtn:btn withTitle:title];
    [btn addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)dealloc {
    
    [self removeObserver:self forKeyPath:@"selectedIndex" context:@"scrollToNextItem"];
}

@end
