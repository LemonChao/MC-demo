//
//  LCCommonWebVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/20.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCCommonWebVC.h"

@interface LCCommonWebVC ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    NSString *urlString;
    NSURL *url;
}
@property(nonatomic, strong) UIWebView *webView;

@end

@implementation LCCommonWebVC

//滑动隐藏导航栏
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self webViewLoadData];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webStr]]];
    self.webView.scrollView.delegate = self;
    [self.view addSubview:self.webView];
    
    
}

- (UIWebView *)webView {
    if (!_webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT)];
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
    NSString *longitude = [ActivityApp shareActivityApp].baseURL;
    NSString *latitude = [ActivityApp shareActivityApp].baseURL;

    //至少id name 不能为空
    if (baseUrl.length == 0 && userId.length == 0 && name.length == 0) return NO;
    
    NSString *urlStr;
    switch (self.type) {
        case CommonWebWeather:
        {
            urlStr = [NSString stringWithFormat:@"%@/farmer/tianqi.jsp?id=%@&&name=%@&&tel=%@long=%@&&lati=%@", baseUrl, userId, name, tel, longitude, latitude];
        }
            break;
            
        case CommonWebGame:
        {
            urlStr = [NSString stringWithFormat:@"%@/farmer/youxi.jsp?id=%@&&name=%@&&tel=%@long=%@&&lati=%@", baseUrl, userId, name, tel, longitude, latitude];
        }
            break;
            
        case CommonWebSpecial:
        {
            urlStr = [NSString stringWithFormat:@"%@/farmer/tczs.jsp?id=%@&&name=%@&&tel=%@long=%@&&lati=%@", baseUrl, userId, name, tel, longitude, latitude];
        }
            break;
        case CommonWebHome:
        {
            urlStr = [NSString stringWithFormat:@"%@/farmer/czzj.jsp?id=%@&&name=%@&&tel=%@long=%@&&lati=%@", baseUrl, userId, name, tel, longitude, latitude];
        }
            break;
            
        case CommonWebInsurance:
        {
            urlStr = [NSString stringWithFormat:@"%@/farmer/baoxian.jsp?id=%@&&name=%@&&tel=%@long=%@&&lati=%@", baseUrl, userId, name, tel, longitude, latitude];
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
    if (_type == CommonWebWeather) return;
    [self.view makeToastActivity];

}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view hideToastActivity];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self.view hideToastActivity];
    
//    [LCAlertTools showTipAlertViewWith:self title:@"糟糕，网络出错了" message:[error localizedDescription] buttonTitle:@"确定" buttonStyle:UIAlertActionStyleDefault];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    
    [self.navigationController setNavigationBarHidden:velocity.y>0 animated:YES];
    
}

@end
