//
//  LCNonghuWebVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/6.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCNonghuWebVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "LCNonghuInfoVC.h"
@interface LCNonghuWebVC ()<UIWebViewDelegate>
{
    NSString *baseUrl;
    NSString *userId;
    NSString *nhId;
    NSString *publicid;     //家庭成员id & 房屋信息id
    NSURL    *url;
}

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation LCNonghuWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self webViewLoadData];
    
    [self.view addSubview:self.webView];
    
    [self createMainView];
}

- (UIWebView *)webView {
    if (!_webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
        _webView.delegate = self;
    }
    return _webView;
}


- (BOOL)creatWebviewUrl {
    baseUrl = [ActivityApp shareActivityApp].baseURL;
    userId = UDSobjectForKey(USERID);

    DLog(@"_________%ld", self.webType);
    switch (self.webType) {
        case 0: //添加 户主
        {
            url = [NSURL URLWithString:StrFormat(@"%@farmer/basicInfo.jsp?userId=%@", baseUrl, userId)];
            self.title = @"新增保户";
        }
            break;
            
        case 3: //修改 户主
        {
            nhId = self.houseHoldModel.nhid;
            publicid = self.houseHoldModel.nhid;
            url = [NSURL URLWithString:StrFormat(@"%@farmer/updatebasicInfo.jsp?userId=%@&&nhId=%@&&id=%@", baseUrl, userId, nhId, publicid)];
            self.title = @"修改户主";
        }
            break;
            
        case 1: // 添加 家庭成员
        {
            nhId = self.houseHoldModel.nhid;

            url = [NSURL URLWithString:StrFormat(@"%@farmer/conditionInfo.jsp?userId=%@&&nhId=%@", baseUrl, userId, nhId)];
            self.title = @"新增成员";
        }
            break;
            
        case 4: // 修改 家庭成员
        {
            nhId = self.houseMemModel.nhid;
            publicid = self.houseMemModel.memberid;
            url = [NSURL URLWithString:StrFormat(@"%@farmer/updateconditionInfo.jsp?userId=%@&&nhId=%@&&id=%@", baseUrl, userId, nhId, publicid)];
            self.title = @"修改家庭成员";
        }
            break;
            
        case 2: // 添加 房屋
        {
            nhId = self.houseHoldModel.nhid;
            url = [NSURL URLWithString:StrFormat(@"%@farmer/houseInfo.jsp?userId=%@&&nhId=%@", baseUrl, userId, nhId)];
            self.title = @"新增房屋";
        }
            break;
            
        case 5: // 修改 房屋信息
        {
            nhId = self.houseInfoModel.nhid;
            publicid = self.houseInfoModel.houseid;
            url = [NSURL URLWithString:StrFormat(@"%@farmer/updatehouseInfo.jsp?userId=%@&&nhId=%@&&id=%@", baseUrl, userId, nhId, publicid)];
            self.title = @"修改房屋信息";
        }
            break;
            
        default:
            break;
    }
    
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


- (void)createMainView {
    
    if (!(_webType == NonghuUpdateHouseInfo || _webType == NonghuUpdateHouseMember)) return;
    
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}


- (void)deleteItemAction {
    
    NSString *message;
    NSDictionary *sendDic;
    
    if (_webType == NonghuUpdateHouseMember) {
        
        message = [NSString stringWithFormat:@"确定删除 %@ 的全部信息", _houseMemModel.name];
        sendDic = @{@"flag":@"deleteFarmerCondition",
                    @"id":_houseMemModel.memberid};
    }
    else if (_webType == NonghuUpdateHouseInfo) {
        
        message = [NSString stringWithFormat:@"确定删除 %@", _houseInfoModel.address];
        sendDic = @{@"flag":@"deleteFarmerHouseInfo",
                    @"id":_houseInfoModel.houseid};
    }

    @WeakObj(self);
    [LCAlertTools showTipAlertViewWith:self title:@"提 示" message:message cancelTitle:@"删除" cancelHandler:^{
        
        [LCAFNetWork POST:@"farmerBasicInfo" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
            [selfWeak.navigationController popViewControllerAnimated:YES];
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            [selfWeak.view makeToast:[error localizedDescription]];
        }];
        
    }];
    
    
}



#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    
    //OC调用JS是基于协议拦截实现的 下面是相关操作
    NSString *absolutePath = request.URL.absoluteString;
    DLog(@"absolutePath = %@, body = %@--%@", absolutePath, request.HTTPBody, request.allHTTPHeaderFields);
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    NSLog(@"dsfqwe = %@", webView.request.URL);

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    NSLog(@"dsfqwe = %@", webView.request.URL);
    
//    NSLog(@"context = %@", context);
//    context[@"onload"] = ^{
//        
//        NSArray *arg = [JSContext currentArguments];
//        for (id obj in arg) {
//            NSLog(@"--%@", obj);
//        }
//    };
    
    
    if (self.webType != NonghuAddHouseHold) return;
    
    //添加户主完成后跳转
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *str = [context[@"onload"] description];
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *farmerId = [str stringByTrimmingCharactersInSet:nonDigits];
    NSString *farmerName = [[str componentsSeparatedByString:@"'"] objectAtIndex:1];
    NSLog(@"onload:%@, id:%@, name:%@",str, farmerId, farmerName);

    LCHouseHoldModel *houseHold = [[LCHouseHoldModel alloc] init];
    houseHold.name = farmerName;
    houseHold.address = @"";
    houseHold.nhid = farmerId;
    
    LCNonghuInfoVC *vc = [[LCNonghuInfoVC alloc] init];
    vc.houseHold = houseHold;
    vc.superBack = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)dealloc {
    
    DLog(@"%@ dealloc-------------------", [self class]);
}


@end
