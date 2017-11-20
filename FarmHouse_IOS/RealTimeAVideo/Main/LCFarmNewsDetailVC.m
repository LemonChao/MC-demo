//
//  LCFarmNewsDetailVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/23.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCFarmNewsDetailVC.h"
#import "LCFarmNewsModel.h"
#import <WebKit/WebKit.h>

@interface LCFarmNewsDetailVC ()
{
    NSInteger newsID;
}

@property(nonatomic, strong)WKWebView *webView;

@end

@implementation LCFarmNewsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"新闻详情";
    [self requestNetworkIsload:NO];
//    [self.view addSubview:self.webView];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
}
- (void)initMainViewWithModel:(LCFarmNewsModel *)model {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-49)];
    scrollView.showsVerticalScrollIndicator = NO;
    
    //title
    NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:self.dataDic];
    CGFloat width = SCREEN_WIDTH - 20;
    
    CGFloat titleHight = [LCTools heightWithString:model.title font:kFontSizeBold18 constrainedToWidth:width];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, width, titleHight)];
    titleLab.text = model.title;
    titleLab.numberOfLines = 0;
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = [UIFont boldSystemFontOfSize:AutoWHGetWidth(18.0)];
    [scrollView addSubview:titleLab];
    
    //timeLab
    CGSize contentSize = [dataDic[@"date"] sizeWithAttributes:@{NSFontAttributeName:kFontSize15}];
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-contentSize.width, NH(titleLab)+10, contentSize.width, contentSize.height)];
    timeLab.text = model.datetime;
    timeLab.textColor = [UIColor blackColor];
    timeLab.font = kFontSize14;
    [scrollView addSubview:timeLab];
    
    //img +line
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, NH(timeLab)+AutoWHGetHeight(15), width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:line];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, NH(line)+AutoWHGetHeight(15), width, width*0.63)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:model.path] placeholderImage:nil];
    [scrollView addSubview:imgView];
    
    //detailLab
    UILabel *detailLab = [LCTools createLable:CGRectMake(10, NH(imgView)+AutoWHGetHeight(15), width, 10) withName:model.content withFont:kSize16];
    
    //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:detailLab.text];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[detailLab.text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:10];//调整行间距
    
    //    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailLab.text length])];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kSize16]} range:NSMakeRange(0, [attributedString length])];
    
    detailLab.attributedText = attributedString;
    [scrollView addSubview:detailLab];
    [detailLab sizeToFit];
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, NH(detailLab)+30);
    [self.view addSubview:scrollView];
    
    
}
- (WKWebView *)webView {
    if (!_webView) {
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
    }
    return _webView;
}

#pragma mark - Network

- (void)requestNetworkIsload:(BOOL)isload {
    newsID = [self.newsid integerValue];
    [self.view makeToastActivity];
    NSDictionary *senDic = @{@"id":@(newsID)};
    [LCAFNetWork POST:@"newsid" params:senDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.view hideToastActivity];
        [self.view hideToastActivity];
        
        if ([responseObject[STATE] intValue] == 1) {
            LCFarmNewsModel *model = [LCFarmNewsModel yy_modelWithDictionary:responseObject[@"data"]];
            [self initMainViewWithModel:model];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view hideToastActivity];
        [self.view makeToast:[error localizedDescription]];
    }];
}




- (void)initMainView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-49)];
    scrollView.showsVerticalScrollIndicator = NO;
    
    //title
    NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:self.dataDic];
    CGFloat width = SCREEN_WIDTH - 20;
    
    CGFloat titleHight = [LCTools heightWithString:dataDic[@"title"] font:kFontSizeBold18 constrainedToWidth:width];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, width, titleHight)];
    titleLab.text = dataDic[@"title"];
    titleLab.numberOfLines = 0;
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = [UIFont boldSystemFontOfSize:AutoWHGetWidth(18.0)];
    [scrollView addSubview:titleLab];
    
    //timeLab
    CGSize contentSize = [dataDic[@"date"] sizeWithAttributes:@{NSFontAttributeName:kFontSize15}];
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-contentSize.width, NH(titleLab)+10, contentSize.width, contentSize.height)];
    timeLab.text = dataDic[@"date"];
    timeLab.textColor = [UIColor blackColor];
    timeLab.font = kFontSize14;
    [scrollView addSubview:timeLab];
    
    //img +line
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, NH(timeLab)+AutoWHGetHeight(15), width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:line];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, NH(line)+AutoWHGetHeight(15), width, width*0.66)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"imgUrl"]] placeholderImage:nil];
    [scrollView addSubview:imgView];
    
    //detailLab
    UILabel *detailLab = [LCTools createLable:CGRectMake(10, NH(imgView)+AutoWHGetHeight(15), width, 10) withName:dataDic[@"content"] withFont:kSize16];
    
    //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:detailLab.text];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[detailLab.text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:10];//调整行间距
    
    //    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailLab.text length])];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kSize16]} range:NSMakeRange(0, [attributedString length])];
    
    detailLab.attributedText = attributedString;
    [scrollView addSubview:detailLab];
    [detailLab sizeToFit];
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, NH(detailLab)+30);
    [self.view addSubview:scrollView];
    
    
}


- (NSDictionary *)dataDic {
    if (!_dataDic) {
        self.dataDic = @{@"content":@"<p>他在海外留学八年，回国后只等着接手亿万资产的家族企业，但他却天天开着跑车游手好闲；他决定自力更生，却在社会上屡屡受挫；2010年，他赌气走进大山，睡起草窝；搬进山里后，曾经在朋友面前很有钱的彭然，硬着头皮找朋友借钱；别人的挖苦，成了他前进的动力。80后的彭然，如何让人刮目相看，一年后实现年营业额三百万元？<br/>\r\n\t&nbsp;</p><p>\r\n\t&nbsp;致富经养殖视频同步解说词：</p><p>\r\n\t这个正在抓鸡的人叫彭然。这里是重庆铜梁县最大的规模养鸡场。凌晨四点抓鸡，早上七点左右，这里的土鸡就会被销往整个铜梁县城和重庆市场。彭然的这家鸡场，一年的营业额达三百万元。而这些，他仅用了一年多就做到了。</p><p>\r\n\t记者：弄得满脸都是泥啊。</p><p>\r\n\t彭然：是，全部都是泥。</p><p>\r\n\t记者：手上也是。</p><p>\r\n\t彭然：对。晚上的时候，鸡是站着不动的，这样抓就好抓。白天到处跑，根本抓不了。</p><p>\r\n\t这个抓起鸡来已经驾轻就熟的年轻人，谁也想不到，他还有另外一个身份。</p><p>\r\n\t朋友朱坤：所谓的富二代，公子哥。</p><p>\r\n\t员工赵晓兰：我还一直都在想这个问题，为什么他妈要他做这个辛苦的活，不相信他家里面有钱。</p><p>\r\n\t彭然是重庆人，家境殷实，资产过亿，在澳大利亚留学八年。养鸡之前，彭然天天过着游手好闲的生活。</p><p>\r\n\t朋友朱坤：玩游戏啊，唱歌啊，酒吧，反正天天这么玩。</p><p>\r\n\t朋友陈毅平：觉得他更像一个小孩，喜欢花时间在游戏上面。</p><p>\r\n\t朋友朱坤：吊儿郎当的，经常比如说做这个事情做做，做到一半，没什么兴趣了，就不做了。</p><p>\r\n\t家里那么有钱，彭然为什么要跑到山里去吃苦，而且还干了养鸡的行当？而更让人觉得蹊跷的是，家里有钱的彭然本应该不为钱愁，可彭然有段时间却只能靠借钱度日，为了二十万元愁得夜不能寐。</p><p>\r\n\t彭然：哪怕我就不要面子，不要脸，也会找朋友借。</p><p>\r\n\t朋友朱坤：第一次，我们认识十几年来第一次向我借钱。</p><p>\r\n\t彭然：就算朋友们怎么说我，怎么挖苦我，先借钱给我再说吧。</p><p>\r\n\t彭然，父母家里资产过亿元，为何还要向朋友借钱？他一个对养鸡一窍不通的门外汉，为什么要跑到山里来吃苦养鸡？而从没做过生意的他，一年后，却硬是靠着自己，实现了年营业额三百万元。</p><p>\r\n\t<img src=\"http://www.nczfj.com/UploadFiles/2012-06/admin/2012689160711.jpg\"/>彭然父母在青海有家大型化工企业，家境殷实。由于父母忙于经营管理，彭然从小学三年级开始就一直上着寄宿学校，17岁时又只身去了澳大利亚留学，一待就是八年，2008年才回到中国。</p><p>\r\n\t母亲张俊秀：在国外那么多年，始终觉得跟我们在一起时间很少，总觉得还是有点亏欠他，我就给他买了一个奥迪TT，每个月给他五千块的工资，经常说，彭然，需不需要钱？</p><p>\r\n\t每月父母经常给的零用钱少则几千，多则上万，彭然的吃穿用度也都由父母的公司实报实销。然而，按照惯例理应接手家族企业的他，却让人大跌眼镜，天天开着跑车，过着游手好闲的生活。</p><p>\r\n\t同学李兴懿：时间完全是颠倒的，白天睡觉，晚上就是耍耍游戏，打牌，反正基本上都是通宵通宵地那种耍。</p><p>\r\n\t母亲张俊秀：我说，我其实很了解你，你是不觉得很空虚？</p><p>\r\n\t彭然：父母就说，你回来又不愿意找工作，那就上班，去自己公司上班。</p><p>\r\n\t彭然确实闲得很空虚，如果去公司上班，时间会过得快一些，还能应付父母，他便欣然同意。但是，朝九晚五的公司规定，对他而言却是一纸空文。</p><p>\r\n\t母亲张俊秀：十点多钟十一点了，有时候穿个睡衣。有时候我都要说他，我说，你还是每天到公司来看一下子。我说，你当个副总，哪个说你不得。</p><p>\r\n\t做母亲的虽然有些看不惯，但张俊秀总觉得亏欠儿子太多。可彭然并不理解父母的心意，除了白天偶尔去下公司，夜生活照常不误。这种生活方式，时间久了，在母亲张俊秀眼里变得格格不入。一天晚上，彭然很晚还没回家，张俊秀忍无可忍便打电话给彭然。</p><p>\r\n\t母亲张俊秀：我说，你出国也有七八年，我也花了起码一百多万。我说，早知道你这样，我一百多万养你吃一辈子你就够了。</p><p>\r\n\t彭然：一听感觉还是挺烦的，我就不做了吧，本来就不喜欢做。</p><p>\r\n\t彭然的回答，让张俊秀火冒三丈。</p><p>\r\n\t母亲张俊秀：你有本事自己养活自己，你不要依靠我。</p><p>\r\n\t彭然：我妈一下就火了，那行，你明天就别来上班了，你的工资全部给你停了。</p><p>\r\n\t母子俩的关系一下子变得僵硬起来，张俊秀痛下决心，果断地停掉了彭然所有的收入。母亲的做法，给了彭然极大的刺激。</p><p>\r\n\t彭然：你想，没钱了怎么办？什么东西都没了。我这个人的性格就是比较不愿意低头。</p><p>\r\n\t母亲把自己说得像寄生虫一般，彭然很不服气，他把这句话记到了心里，赌气要自力更生。</p><p><br/></p>",
                         @"title":@"如何让人刮目相看，一年后实现年营业额三百万元？",
                         @"imgUrl":@"http://36.111.32.33:10038/WebServer/images/67128531_3.jpg",
                         @"date":@"2016-12-09"};
    }
    return _dataDic;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
