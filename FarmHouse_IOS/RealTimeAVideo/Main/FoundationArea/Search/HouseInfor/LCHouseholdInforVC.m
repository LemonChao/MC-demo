//
//  LCHouseholdInforVC.m
//  RealTimeAVideo
//
//  Created by sunpeng on 2017/3/28.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCHouseholdInforVC.h"

@interface LCHouseholdInforVC ()<UIWebViewDelegate>{
    NSURL *currentUrl;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LCHouseholdInforVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  //  self.view.backgroundColor = BGColor;
    [self setleftBarButtonItm];
    [self getHtml];
}

- (void)setleftBarButtonItm{
    self.navigationItem.title = _seaModel.farmer.name;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStyleDone) target:self action:@selector(backBefore)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)backBefore{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        
    }else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)getHtml{
    currentUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/farmer/detailInfo.jsp?flag=searchFarmerBasicInfo&&userId=%@&&nhId=%@",BASEURL, _seaModel.user_id, _seaModel.nhId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:currentUrl];
    [_webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
     [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
