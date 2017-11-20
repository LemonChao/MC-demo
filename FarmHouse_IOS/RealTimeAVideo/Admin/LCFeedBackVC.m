//
//  LCFeedBackVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/21.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCFeedBackVC.h"
#import "UITextViewPlaceholder.h"

@interface LCFeedBackVC ()
{
    NSDictionary *infoDic;
}
@property (strong, nonatomic) UITextViewPlaceholder *feedTextView;

@end

@implementation LCFeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    [self initMainView];
    
    if ([UDSobjectForKey(ISLOGIN) intValue]) { //login [UDSobjectForKey(ISLOGIN) intValue]
        infoDic = UDSobjectForKey(USERINFO);
    }
    
    
}


- (void)initMainView {
    self.feedTextView = [[UITextViewPlaceholder alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20,AutoWHGetHeight(150))];
    _feedTextView.placeholder = @"说点什么吧";
    _feedTextView.textColor = [UIColor blackColor];
    _feedTextView.font = kFontSize16;
    [_feedTextView setCornerRadius:5];
    [_feedTextView setBorderWidth:1 bolorColor:[UIColor lightGrayColor]];
    [self.view addSubview:_feedTextView];
    NSLog(@"rect%@",NSStringFromCGRect(_feedTextView.frame));
    
    //OKButton
    UIButton *OKBUtton = [LCTools createButton:CGRectMake(10, NH(_feedTextView)+40, WIDTH(_feedTextView), AutoWHGetHeight(30)) withName:@"提 交" normalImg:nil highlightImg:nil selectImg:nil];
    OKBUtton.titleLabel.font = kFontSize17;
    [OKBUtton setCornerRadius:5];
    [OKBUtton setBackgroundColor:MainColor];
    [OKBUtton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [OKBUtton addTarget:self action:@selector(OKButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:OKBUtton];
}



- (void)OKButtonClick:(id)sender {
   
    NSDictionary *sendDic = @{@"flag":@"PutOpinion",
                              USERID:UDSobjectForKey(USERID),
                              @"text":self.feedTextView.text,
                              @"phone":infoDic ? infoDic[@"phone"] : @" "};
    
    [LCAFNetWork POST:@"opinion" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        if ([[responseObject objectForKey:STATE] intValue]) {
            //
            [self.view makeToast:[responseObject objectForKey:MESSAGE] duration:1 position:CSToastPositionCenter];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        //
        [self.view makeToast:[error localizedDescription] duration:1 position:CSToastPositionCenter];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
