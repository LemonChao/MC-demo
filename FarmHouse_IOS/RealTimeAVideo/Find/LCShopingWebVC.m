//
//  LCShopingWebVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/13.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCShopingWebVC.h"

@interface LCShopingWebVC ()<UIWebViewDelegate>
{
    NSString *urlString;
    NSURL *url;
}
@property(nonatomic, strong) UIWebView *webView;

@end

@implementation LCShopingWebVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self webViewLoadData];
    
    [self.view addSubview:self.webView];
    
}

- (UIWebView *)webView {
    if (!_webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
        _webView.delegate = self;
    }
    return _webView;
}

- (BOOL)creatWebviewUrl {
    NSString *baseUrl = [ActivityApp shareActivityApp].baseURL;
    NSString *userId = [NSString stringWithFormat:@"%@", UDSobjectForKey(USERID)];
    NSDictionary *infoDic = UDSobjectForKey(USERINFO);
    NSString *tel = infoDic[@"phone"];
    NSString *name = infoDic[@"name"];
    
    if (baseUrl.length == 0 && userId.length == 0 && name.length == 0) return NO;
    
    NSString *urlStr;
    switch (self.type) {
        case FindColumnWebGame:
        {
            urlStr = [NSString stringWithFormat:@"%@/farmer/youxi.jsp?id=%@&&name=%@&&tel=%@", baseUrl, userId, name, tel];
        }
            break;
            
        case FindColumnWebShoping:
        {
            urlStr = [NSString stringWithFormat:@"%@/farmer/gouwu.jsp?id=%@&&name=%@&&tel=%@", baseUrl, userId, name, tel];
        }
            break;
    }
    
    url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return YES;

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


- (BOOL)navigationShouldPopOnBackButton {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        return NO;
    }
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.view makeToastActivity];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view hideToastActivity];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self.view hideToastActivity];

    [LCAlertTools showTipAlertViewWith:self title:@"糟糕，网络出错了" message:[error localizedDescription] buttonTitle:@"确定" buttonStyle:UIAlertActionStyleDefault];
}


@end
