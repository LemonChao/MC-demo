//
//  LCGatherWebVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/5/17.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCGatherWebVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "LCNonghuInfoVC.h"

@interface LCGatherWebVC ()<UIWebViewDelegate>
{
    NSString *baseUrl;
    NSString *userId;
    NSURL *webViewUrl;
}

@property(nonatomic, strong) UIWebView *webView;

@end

@implementation LCGatherWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self webViewLoadData];
    
    [self.view addSubview:self.webView];
    
    if (_operationType == GatherWebOperationUpdate) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(rightDeleteItemAction)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }

}

- (void)rightDeleteItemAction {
    
    NSDictionary *deleteDic;
    
    switch (_webType) {
        case GatherWebTypePlant:
        {
            deleteDic = @{@"flag":@"deleteplant",
                        @"id":_cropModel.cropid};
        }
            break;
            
        case GatherWebTypeFarming:
        {
            deleteDic = @{@"flag":@"deletefarming",
                        @"id":_cropModel.cropid};
        }
            break;
            
        case GatherWebTypeSpecial:
        {
            deleteDic = @{@"flag":@"deletespecialty",
                        @"id":_cropModel.cropid};
        }
            break;
            
        case GatherWebTypeEquipment:
        {
            deleteDic = @{@"flag":@"deleteequipment",
                        @"id":_cropModel.cropid};
        }
            break;
            
        default://error
            break;
    }
    
    @WeakObj(self);
    [LCAFNetWork POST:@"collect" params:deleteDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[STATE] intValue] == 1) {
            
            [selfWeak.navigationController popViewControllerAnimated:YES];
            if (_backRefresh) {
                _backRefresh();
            }

        }else {
            [selfWeak.view makeToast:responseObject[MESSAGE]];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [selfWeak.view makeToast:[error localizedDescription]];
    }];
    

    
}


- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
        _webView.delegate = self;
    }
    return _webView;
}


-(BOOL)navigationShouldPopOnBackButton {
    if (_backRefresh) {
        _backRefresh();
    }
    return YES;
}


- (BOOL)creatWebViewUrl {
    
    baseUrl = [ActivityApp shareActivityApp].baseURL;
    userId = UDSobjectForKey(USERID);

    if (baseUrl == nil) {
        return NO;
    }
    
    NSString *url;
    switch (_webType) {
        case GatherWebTypePlant:
        {
            url = [NSString stringWithFormat:@"%@zhongzhi/plant.jsp?", baseUrl];
        }
            break;
            
        case GatherWebTypeFarming:
        {
            url = [NSString stringWithFormat:@"%@zhongzhi/farming.jsp?", baseUrl];
        }
            break;
            
        case GatherWebTypeSpecial:
        {
            url = [NSString stringWithFormat:@"%@zhongzhi/specialty.jsp?", baseUrl];
        }
            break;
            
        case GatherWebTypeEquipment:
        {
            url = [NSString stringWithFormat:@"%@zhongzhi/equipment.jsp?", baseUrl];
        }
            break;
            
        default:
            break;
    }
    
    
    switch (_operationType) {
        case GatherWebOperationPlain:
        {
            url = [url stringByAppendingString:[NSString stringWithFormat:@"userid=%@", userId]];
        }
            break;
            
        case GatherWebOperationAdd:
        {
            url = [url stringByAppendingString:[NSString stringWithFormat:@"farmerid=%@", _cropModel.farmerid]];
        }
            break;
            
        case GatherWebOperationUpdate:
        {
            url = [url stringByAppendingString:[NSString stringWithFormat:@"farmerid=%@&id=%@", _cropModel.farmerid, _cropModel.cropid]];
        }
            break;
            
        default: //error
            break;
    }
    
    webViewUrl = [NSURL URLWithString:url];
    return YES;
}

- (void)webViewLoadData {
    BOOL result = [self creatWebViewUrl];
    if (!result) {//链接不完整
        [LCAlertTools showTipAlertViewWith:self
                                     title:@"提示"
                                   message:@"网络连接走失了\n请重试"
                               cancelTitle:@"确定"cancelHandler:^{
                                   [self.navigationController popViewControllerAnimated:YES];
                               }];
        
    }

    
    [self.webView loadRequest:[NSURLRequest requestWithURL:webViewUrl]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    DLog(@"111 type = %ld", navigationType);
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    DLog(@"2222 %s", __FUNCTION__);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    DLog(@"3333 %s", __FUNCTION__);

    
    if (_operationType != GatherWebOperationPlain) return;
    //添加户主完成后跳转
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *str = [context[@"onload"] description];
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *farmerId = [str stringByTrimmingCharactersInSet:nonDigits];
    NSString *farmerName = [[str componentsSeparatedByString:@"'"] objectAtIndex:1];
    NSLog(@"context:%@ onload:%@, id:%@, name:%@",context, str, farmerId, farmerName);

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
    DLog(@"44444 %s", __FUNCTION__);

}

- (void)dealloc {
    
    DLog(@"%@ dealloc-------------------", [self class]);
}


@end
