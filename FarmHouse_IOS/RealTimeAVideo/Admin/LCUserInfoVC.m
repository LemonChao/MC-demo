//
//  LCUserInfoVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/17.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCUserInfoVC.h"
#import "LCAddressPickerView.h"
#import "LCModifyPhoneNumVC.h"
#import "LCModifyPasswordVC.h"
#import "LCNonghuInfoVC.h" //户主界面

@interface LCUserInfoVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableDictionary *infoDic;
    NSString     *province;
    NSString     *city;
    NSString     *county;
}
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLab;
@property (weak, nonatomic) IBOutlet UILabel *passwordLab;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *positionLab;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UITextField *adressLab;
@property (weak, nonatomic) IBOutlet UITextField *inviteField;
@property (weak, nonatomic) IBOutlet UIImageView *protraitView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *phoneNumTap;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *passwordTap;

- (IBAction)OKButtonClick:(id)sender;
- (IBAction)areaButtonClick:(id)sender;


@end

@implementation LCUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人信息";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"退出登录" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemAction)];
    self.navigationItem.rightBarButtonItem = item;
    
    infoDic = [UDSobjectForKey(USERINFO) mutableCopy];
    [self refreshUIWithInfodic];
}

- (void)refreshUIWithInfodic{

    if (!infoDic) return;
    _phoneNumLab.text = infoDic[@"phone"];
    NSString *userImgUrl = StrFormat(@"%@%@", [ActivityApp shareActivityApp].baseURL, infoDic[@"headurl"]);
    [_protraitView sd_setImageWithURL:[NSURL URLWithString:userImgUrl]];
    _nameField.text = infoDic[@"name"];
    _positionLab.text = [infoDic[@"power"] intValue] ? @"协保员":@"";
    _adressLab.text = infoDic[@"address"];
    
    NSString *areaStr = StrFormat(@"%@ %@ %@",infoDic[@"province"], infoDic[@"city"], infoDic[@"county"]);
    [_areaButton setTitle:areaStr forState:UIControlStateNormal];
    _areaButton.userInteractionEnabled = [infoDic[@"power"] intValue] ? NO : YES;
    
    province = infoDic[@"province"];
    city     = infoDic[@"city"];
    county   = infoDic[@"county"];

}
- (IBAction)validInputs:(UITextField *)sender {
    NSInteger _maxWords = 10;
    NSString *toBeString = sender.text;
    //获取高亮部分
    UITextRange *selectedRange = [sender markedTextRange];
    UITextPosition *position = [sender positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > _maxWords)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:_maxWords];
            if (rangeIndex.length == 1)
            {
                sender.text = [toBeString substringToIndex:_maxWords];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _maxWords)];
                sender.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }}

- (IBAction)phoneNumTap:(UITapGestureRecognizer *)sender {
    
    LCModifyPhoneNumVC *modifyPhoneVC = [[LCModifyPhoneNumVC alloc] init];
    [self.navigationController pushViewController:modifyPhoneVC animated:YES];
    DLog(@"infoDic=%@", infoDic);
}

- (IBAction)passwordTap:(UITapGestureRecognizer *)sender {
    
    LCModifyPasswordVC *modifyPassword = [[LCModifyPasswordVC alloc] init];
    [self.navigationController pushViewController:modifyPassword animated:YES];
 
}


- (IBAction)protraitTap:(UITapGestureRecognizer *)sender {
    DLog(@"更换头像");
    NSArray *titleArr = @[@"拍照",@"从相册中选取"];
    NSArray *styleArr = @[[NSNumber numberWithInteger:UIAlertActionStyleDefault],
                          [NSNumber numberWithInteger:UIAlertActionStyleDefault]];
    
    [LCAlertTools showActionSheetWith:self title:nil message:nil cancelButtonTitle:@"取消" actionTitleArray:titleArr actionStyleArray:styleArr cancelHandler:nil callbackBlock:^(NSInteger actionIndex) {
        DLog(@"%@-%ld", titleArr[actionIndex], actionIndex);
        UIImagePickerControllerSourceType sourceType;
        if (actionIndex == 0) { //拍照
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [LCAlertTools showTipAlertViewWith:self title:@"提示" message:@"没有找到可用的相机" buttonTitle:@"确定" buttonStyle:UIAlertActionStyleCancel];
                return;
            }
            sourceType = UIImagePickerControllerSourceTypeCamera;
            
        }else {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        pickerVC.delegate = self;
        pickerVC.allowsEditing = YES;
        pickerVC.sourceType = sourceType;
        [self presentViewController:pickerVC animated:YES completion:nil];
    }];
    
}

- (void)uploadUserPortrait:(NSData *)data fileName:(NSString *)fileName {
    NSDictionary *sendDic = @{@"id":UDSobjectForKey(USERID)?UDSobjectForKey(USERID):@"",
                              @"img":@"keyiweikogn"}; //可以为空
    NSString *nameStr = StrFormat(@"%@.jpg",[self dataWithFormat:@"YYYYMMddHHmmss"]);
    
    DLog(@"sendDic:%@,date%@", sendDic, nameStr);
    [self.view makeToastActivity];
    
    [LCAFNetWork uploadWithURL:@"headimage" params:sendDic fileData:data name:@"upload" fileName:nameStr mimeType:@"image/jpeg" progress:^(NSProgress *progress) {
        DLog(@"+++%@", progress);
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"responseObject----%@",responseObject);
        
        [self.view hideToastActivity];
        if ([responseObject[STATE] intValue] == 1) {
            NSString *userImgUrl = StrFormat(@"%@%@", [ActivityApp shareActivityApp].baseURL, responseObject[@"data"]);
            [self.protraitView sd_setImageWithURL:[NSURL URLWithString:userImgUrl]];
            [infoDic setObject:responseObject[@"data"] forKey:@"headurl"];
            [[NSUserDefaults standardUserDefaults] setObject:infoDic forKey:USERINFO];
        }
        
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"error:%@", [error localizedDescription]);
    }];
    
}

#define mark - UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    DLog(@"imgDic%@", info);
    //    [self.userPhotoImg setImage:image];
    
    NSData *jpegData = UIImageJPEGRepresentation(image, 0.2);
    [self uploadUserPortrait:jpegData fileName:[info valueForKey:UIImagePickerControllerReferenceURL]];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/** update user infomation */
- (IBAction)OKButtonClick:(id)sender {
    
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    NSString *sessid = [[NSUserDefaults standardUserDefaults] objectForKey:SESSID];

    
    NSDictionary *sendDic = @{@"flag":@"UpdateUser",
                              USERID:userid,
                              SESSID:sessid,
                              @"username":_nameField.text,
                              @"address":_adressLab.text,
                              @"invitecode":_inviteField.text,
                              @"province":province,
                              @"city":city,
                              @"county":county};
    
    DLog(@"sendDic = %@", sendDic);
    [LCAFNetWork POST:ewlWebServerUser params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        //返回时缺少了 sessid 字段，后台不想改
        if ([[responseObject objectForKey:@"state"] integerValue]) {
            
            NSDictionary *dic = [[responseObject objectForKey:@"data"] copy];
            DLog(@"phone%@", dic[@"phone"]);
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:USERINFO];
            [[NSUserDefaults standardUserDefaults] synchronize];

            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self.view makeToast:[responseObject objectForKey:@"message"] duration:1 position:CSToastPositionCenter];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        //
        [self.view makeToast:[error localizedDescription] duration:1 position:CSToastPositionCenter];
    }];
    
}

- (void)rightBarItemAction {
    [LCAlertTools showTipAlertViewWith:self title:@"提示" message:@"您将要退出当前账号" cancelTitle:@"确定" cancelHandler:^{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:ISLOGIN];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERINFO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkLoginToRefreshUI" object:nil];
        [self.navigationController popViewControllerAnimated:YES];

    }];
    
}

- (IBAction)areaButtonClick:(id)sender {
    
    LCAddressPickerView *pickView = [[LCAddressPickerView alloc] initWithTWFrame:self.view.frame TWselectCityTitle:@"选择地区"];
    [pickView showCityView:^(NSString *proviceStr, NSString *cityStr, NSString *distr) {
        [self.areaButton setTitle:StrFormat(@"%@ %@ %@",proviceStr, cityStr, distr) forState:UIControlStateNormal];
        province = proviceStr;
        city = cityStr;
        county = distr;
    }];
    
}

- (IBAction)improvementMoreNews:(id)sender {
    LCHouseHoldModel *model = [[LCHouseHoldModel alloc] init];
    model.nhid = UDSobjectForKey(USERID)?UDSobjectForKey(USERID):@"";
    model.name = infoDic[@"name"];
    
    LCNonghuInfoVC *vc = [[LCNonghuInfoVC alloc] init];
    vc.houseHold = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
