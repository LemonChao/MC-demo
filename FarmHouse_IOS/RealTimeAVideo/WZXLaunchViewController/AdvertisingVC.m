//
//  AdvertisingVC.m
//  E-VillageUI
//
//  Created by Lemon on 16/11/9.
//  Copyright © 2016年 LemonChao. All rights reserved.
//

#import "AdvertisingVC.h"
#import <WebKit/WKWebView.h>


@interface AdvertisingVC ()

@end

@implementation AdvertisingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self HomeWebView];
}

- (void)HomeWebView
{
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [self.view addSubview:webView];
    
    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
    
    
    if(self.AppDelegateSele == -1)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    }
    
}

- (void)back
{
    
    if(self.WebBack){
        
        self.WebBack();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSString *)urlStr
{
    if(_urlStr == nil)
    {
        _urlStr = [NSString string];
    }
    return _urlStr;
}

@end
