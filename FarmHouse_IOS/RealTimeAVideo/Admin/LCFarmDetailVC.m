//
//  LCFarmDetailVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/12/26.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCFarmDetailVC.h"

@interface LCFarmDetailVC ()<UIWebViewDelegate>
{
    NSString *baseUrl;
    NSString *userId;
    NSString *nhId;
    NSURL    *url;
}
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation LCFarmDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self webViewLoadData];
    
    [self.view addSubview:self.webView];
    
}

- (UIWebView *)webView {
    if (!_webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
       // _webView.navigationDelegate = self;
        _webView.delegate = self;
    }
    return _webView;
}

- (BOOL)creatWebviewUrl {
    baseUrl = [ActivityApp shareActivityApp].baseURL;
    userId = UDSobjectForKey(USERID);
    nhId = self.hholdeModel.masterid;
    if (baseUrl && userId && nhId) {
        url = [NSURL URLWithString:StrFormat(@"%@farmer/detailInfo.jsp?flag=searchFarmerBasicInfo&&userId=%@&&nhId=%@", baseUrl, userId, nhId)];
        return YES;
    }
    return NO;
}

- (void)webViewLoadData {
    BOOL result = [self creatWebviewUrl];
    if (!result) {//链接不完整
        [LCAlertTools showTipAlertViewWith:self
                                     title:@"提示"
                                   message:@"网络连接走失了\n请重试"
                               cancelTitle:@"确定"cancelHandler:^{
                                   [self.navigationController popViewControllerAnimated:YES];
                               }];

    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

//#pragma mark - WKNavigationDelegate
//
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
//    DLog(@"start load");
//    [self.view makeToastActivity];
//}
//
//- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
//    DLog(@"finish load");
//    [self.view hideToastActivity];
//}
//
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//    DLog(@"jie xi error");
//}
//- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//    DLog(@"load error");
//}
//
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//    DLog(@"message%@", message);
//    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        completionHandler();
//    }]];
//    [self presentViewController:alertController animated:YES completion:nil];
//
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
