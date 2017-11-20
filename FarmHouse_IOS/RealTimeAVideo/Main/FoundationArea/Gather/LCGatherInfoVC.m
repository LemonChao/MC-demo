//
//  LCGatherInfoVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/12/22.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCGatherInfoVC.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface LCGatherInfoVC ()<WKNavigationDelegate,UIWebViewDelegate,WKUIDelegate>

@end

@implementation LCGatherInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatWebView];
}

- (void)creatWebView {
//    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
//    webView.navigationDelegate = self;
//    webView.UIDelegate = self;
//    [self.view addSubview:webView];
//    
//    NSURL *url = [NSURL URLWithString:StrFormat(@"%@/farmer/basicInfo.jsp?userId=%@",[ActivityApp shareActivityApp].baseURL, UDSobjectForKey(USERID))];
//
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];    
//    [webView loadRequest:request];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSURL *url = [NSURL URLWithString:StrFormat(@"%@/farmer/basicInfo.jsp?userId=%@",[ActivityApp shareActivityApp].baseURL, UDSobjectForKey(USERID))];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];

}

#pragma mark - WKNavigationDelegate

/*
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    DLog(@"start load");
    [self.view makeToastActivity];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    DLog(@"finish load");
    [self.view hideToastActivity];
    
    //加上这一句进来就出提醒框，好像触发来了 WKUIDelegate
//    [webView evaluateJavaScript:@"queryTown()" completionHandler:^(id item, NSError * _Nullable error) {
//        
//        if (!error) {
//            NSLog(@"item = %@", item);
//        }
//        NSLog(@"123------%@", error);
//        //
//    }];

}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    DLog(@"jie xi error");
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    DLog(@"load error");
    
  
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
}

//遵循 WKUIdelegate,实现方法
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    DLog(@"message%@", message);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    DLog(@"message%@", message);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
*/



@end
