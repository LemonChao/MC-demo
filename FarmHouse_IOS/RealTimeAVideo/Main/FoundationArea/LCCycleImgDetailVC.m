//
//  LCCycleImgDetailVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/12/22.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCCycleImgDetailVC.h"
#import <WebKit/WebKit.h>

@interface LCCycleImgDetailVC ()<WKNavigationDelegate>

@end

@implementation LCCycleImgDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatWebView];
}

- (void)creatWebView {
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.view makeToastActivity];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.view hideToastActivity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
