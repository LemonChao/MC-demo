//
//  LCDisasterVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/28.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCDisasterVC.h"
#import <WebKit/WebKit.h>

@interface LCDisasterVC ()<WKNavigationDelegate,WKUIDelegate,UIWebViewDelegate>
{
//    NSString *baseURL;
//    NSString *userid;
}
@property(nonatomic, strong)UIWebView *webView;

@end

@implementation LCDisasterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.type ? @"受损状况" : @"救助物资";
    
    [self.view addSubview:self.webView];

    [self webViewLoadData];
}

- (UIWebView *)webView {
    if (!_webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT)];
        _webView.delegate = self;
    }
    return _webView;

}

//设置左边按键
- (UIButton*)set_leftButton {
    UIButton *left_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [left_button setImage:[UIImage imageNamed:@"back_64"] forState:UIControlStateNormal];
    [left_button setImage:[UIImage imageNamed:@"back_64"] forState:UIControlStateHighlighted];
    return left_button;
}

//设置左边事件
- (void)left_button_event:(UIButton*)sender {
    if (self.popBlock) {
        self.popBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewLoadData {
    NSString *baseURL = [NSString stringWithString:[ActivityApp shareActivityApp].baseURL];
    NSString *userid = UDSobjectForKey(USERID);
    NSURL *url;
    
    //http://36.111.32.33:10038/WebServer/farmer/material.jsp?reportid=1354&&farmerinfoid=262&&userid=10079
    if (self.type == VCTypeDisaster) {
        
        url = [NSURL URLWithString:StrFormat(@"%@/farmer/disaster.jsp?reportid=%@&&farmerinfoid=%@&&userid=%@",baseURL, self.model.caseid, self.model.nhId, userid)];
        
    }else if (self.type == VCTypeRelief) {
        
        url = [NSURL URLWithString:StrFormat(@"%@/farmer/material.jsp?reportid=%@&&farmerinfoid=%@&&userid=%@",baseURL, self.model.caseid, self.model.nhId, userid)];
        
    }
//    NSURL *url = [NSURL URLWithString:StrFormat(@"%@/farmer/disaster.jsp?reportid=%@&&farmerinfoid=%@&&userid=%@",baseURL, self.model.caseid, self.model.nhId, userid)];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}


#pragma mark - WKNavigationDelegate
/*
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    DLog(@"start load");
    [self.view makeToastActivity];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    DLog(@"finish load");
    [self.view hideToastActivity];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    DLog(@"jie xi error");
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    DLog(@"load error");
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    DLog(@"message%@", message);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
*/


@end
