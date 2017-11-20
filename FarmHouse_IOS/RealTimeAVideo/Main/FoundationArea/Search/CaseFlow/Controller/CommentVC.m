//
//  CommentVC.m
//  RealTimeAVideo
//
//  Created by sunpeng on 2017/3/28.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "CommentVC.h"

//默认最大输入字数为  kMaxTextCount  300
#define kMaxTextCount 300

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备高度
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备宽度
#define TextViewTrimmingStr(text) [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

@interface CommentVC ()<UITextViewDelegate,UIScrollViewDelegate>{
    //备注文本View高度
    float noteTextHeight;
    float pickerViewHeight;
    float allViewHeight;
    MBProgressHUD *_hud;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mianScrollView;

@end

@implementation CommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_mianScrollView setDelegate:self];
    self.showInView = _mianScrollView;
    
    [self initPickerView];
    
    [self initViews];
    
    [self setleftBarButtonItm];
}

/**
 *  初始化视图
 */
- (void)initViews{
    _noteTextBackgroudView = [[UIView alloc]init];
    _noteTextBackgroudView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    //文本输入框
    _noteTextView = [[JGTextView alloc]init];
    _noteTextView.placeholder = @"点击输入内容";
    _noteTextView.keyboardType = UIKeyboardTypeDefault;
    //文字样式
    // [_noteTextView setFont:[UIFont fontWithName:@"Heiti SC" size:15.5]];
    //    _noteTextView.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    [_noteTextView setTextColor:[UIColor blackColor]];
    _noteTextView.delegate = self;
    _noteTextView.font = [UIFont systemFontOfSize:15.5];
    
    _textNumberLabel = [[UILabel alloc]init];
    _textNumberLabel.textAlignment = NSTextAlignmentRight;
    _textNumberLabel.font = [UIFont boldSystemFontOfSize:12];
    _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    _textNumberLabel.backgroundColor = [UIColor whiteColor];
    _textNumberLabel.text = [NSString stringWithFormat:@"0/%d    ",kMaxTextCount];
    
    
    
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1.0];
    [_mianScrollView addSubview:_lineView];
    
    
    
    _explainLabel = [[UILabel alloc]init];
    //    _explainLabel.text = @"添加图片不超过9张，文字备注不超过300字";
    // _explainLabel.text = [NSString stringWithFormat:@"添加图片不超过9张，文字备注不超过%d字",kMaxTextCount];
    _explainLabel.text = @"最多添加9张图片";
    //发布按钮颜色
    _explainLabel.textColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1.0];
    _explainLabel.textAlignment = NSTextAlignmentCenter;
    _explainLabel.font = [UIFont boldSystemFontOfSize:12];
    
    //    //发布按钮样式->可自定义!
    //    _submitBtn = [[UIButton alloc]init];
    //    [_submitBtn setTitle:@"发布" forState:UIControlStateNormal];
    //    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [_submitBtn setBackgroundColor:EWBMainColor];
    //
    //    //圆角
    //    //设置圆角
    //    [_submitBtn.layer setCornerRadius:4.0f];
    //    [_submitBtn.layer setMasksToBounds:YES];
    //    [_submitBtn.layer setShouldRasterize:YES];
    //    [_submitBtn.layer setRasterizationScale:[UIScreen mainScreen].scale];
    //
    //    [_submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_mianScrollView addSubview:_noteTextBackgroudView];
    [_mianScrollView addSubview:_noteTextView];
    [_mianScrollView addSubview:_textNumberLabel];
    [_mianScrollView addSubview:_explainLabel];
    [_mianScrollView addSubview:_submitBtn];
    
    [self updateViewsFrame];
}
/**
 *  界面布局 frame
 */
- (void)updateViewsFrame{
    
    if (!allViewHeight) {
        allViewHeight = 0;
    }
    if (!noteTextHeight) {
        noteTextHeight = 100;
    }
    
    _noteTextBackgroudView.frame = CGRectMake(0, 0, SCREENWIDTH, noteTextHeight);
    
    //文本编辑框
    _noteTextView.frame = CGRectMake(15, 0, SCREENWIDTH - 30, noteTextHeight);
    
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15, SCREENWIDTH-10, 0);
    
    
    //photoPicker
    [self updatePickerViewFrameY:_textNumberLabel.frame.origin.y + _textNumberLabel.frame.size.height];
    
    //虚线
    _lineView.frame = CGRectMake(0, [self getPickerViewFrame].origin.y+[self getPickerViewFrame].size.height, SCREENWIDTH, .5);
    
    //说明文字
    _explainLabel.frame = CGRectMake(0, [self getPickerViewFrame].origin.y+[self getPickerViewFrame].size.height+10, SCREENWIDTH, 20);
    
    
    
    
    //    //发布按钮
    //    _submitBtn.bounds = CGRectMake(10, _explainLabel.frame.origin.y+_explainLabel.frame.size.height +30, SCREENWIDTH -20, 40);
    //    _submitBtn.frame = CGRectMake(10, _explainLabel.frame.origin.y+_explainLabel.frame.size.height +30, SCREENWIDTH -20, 40);
    //
    //
    allViewHeight = noteTextHeight + [self getPickerViewFrame].size.height + 30 + 60;
    
    _mianScrollView.contentSize = self.mianScrollView.contentSize = CGSizeMake(0,allViewHeight);
}

/**
 *  恢复原始界面布局
 */
-(void)resumeOriginalFrame{
    _noteTextBackgroudView.frame = CGRectMake(0, 0, SCREENWIDTH, noteTextHeight);
    //文本编辑框
    _noteTextView.frame = CGRectMake(15, 0, SCREENWIDTH - 30, noteTextHeight);
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15, SCREENWIDTH-10, 15);
}

- (void)pickerViewFrameChanged{
    [self updateViewsFrame];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [self textChanged];
    return YES;
}

//文本框每次输入文字都会调用  -> 更改文字个数提示框
- (void)textViewDidChangeSelection:(UITextView *)textView{
    [self textChanged];
}

/**
 *  文本高度自适应
 */
-(void)textChanged{
    
    CGRect orgRect = self.noteTextView.frame;//获取原始UITextView的frame
    
    //获取尺寸
    CGSize size = [self.noteTextView sizeThatFits:CGSizeMake(self.noteTextView.frame.size.width, MAXFLOAT)];
    
    orgRect.size.height=size.height+10;//获取自适应文本内容高度
    
    
    //如果文本框没字了恢复初始尺寸
    if (orgRect.size.height > 100) {
        noteTextHeight = orgRect.size.height;
    }else{
        noteTextHeight = 100;
    }
    
    [self updateViewsFrame];
}

/**
 *  发布按钮点击事件
 */
- (void)submitBtnClicked{
    //检查输入
    [self getBigImageArray];
    [_noteTextView endEditing:YES];
    if (![self checkInput]) {
        return;
    }
    //输入正确将数据上传服务器->
    [self submitToServer];
}

#pragma maek - 检查输入
- (BOOL)checkInput{
    //文本框没字
    if (TextViewTrimmingStr(_noteTextView.text).length != 0||[self getBigImageArray].count != 0) {
        return YES;
    }
    [self.view makeToast:@"输入文字或图片不能为空" duration:1.0 position:CSToastPositionCenter];
    return NO;
}
- (NSString *)currentDateString{
    //获取系统当前时间
    NSDate *currentDate = [NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    return  [dateFormatter stringFromDate:currentDate];
}

#pragma mark - 上传数据到服务器前将图片转data（上传服务器用form表单：未写）
- (void)submitToServer{
    // 可以选择上传大图数据或者小图数据->
    //大图数据
    NSArray *bigImageDataArray = [self getBigImageArray];
    //如果有图片, 压缩图片上传, 没有则不上穿
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (bigImageDataArray.count > 0) {
            //当前名字
            NSString *currentName = [self currentDateString];
            //Zip文件夹
            NSString *cachePath = [SandBoxManager creatPathUnderCaches:@"/uploadzip"];
            //Zip路径
            NSString *zipFilePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",[currentName stringByAppendingString:@".zip"]]];
            NSMutableArray *zipArray = @[].mutableCopy;
            [bigImageDataArray enumerateObjectsUsingBlock:^(UIImage  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [zipArray addObject:[SandBoxManager writeToDirectory:cachePath WithImage:obj imageName: StrFormat(@"%lu%@", idx,[self currentDateString]) imgType:@"jpg"]];
            }];
            if ([SSZipArchive createZipFileAtPath:zipFilePath withFilesAtPaths:zipArray]) {
                NSLog(@"压缩成功%@", zipFilePath);
                NSString *upContent = TextViewTrimmingStr(_noteTextView.text)?_noteTextView.text:@"";
                [self uploadDataWith:upContent filePath:zipFilePath fileName:[NSString stringWithFormat:@"%@.zip", _model.number]];
            }else {
                NSLog(@"压缩失败");
            }
        }else{
            [self uploadDataWith:_noteTextView.text filePath:nil fileName:nil];
        }
    });
    
    
    
    
    //    //小图数组
    //    NSArray *smallImageArray = self.imageArray;
    //
    //    //小图二进制数据
    //    NSMutableArray *smallImageDataArray = [NSMutableArray array];
    //
    //    for (UIImage *smallImg in smallImageArray) {
    //        NSData *smallImgData = UIImagePNGRepresentation(smallImg);
    //        [smallImageDataArray addObject:smallImgData];
    //    }
    //    NSLog(@"上传服务器... +++ 文本内容:%@",_noteTextView.text);
    //
    //    NSString *str = TextViewTrimmingStr(_noteTextView.text).length > 0?_noteTextView.text:@"";
    //    [self uploadDataWith:str];
    //    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"发布成功!" preferredStyle:UIAlertControllerStyleAlert];
    //    UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        [self dismissViewControllerAnimated:YES completion:nil];
    //    }];
    //    [alertController addAction:actionCacel];
    //    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIScrollViewDelegate
//用户向上偏移到顶端取消输入,增强用户体验
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //    NSLog(@"偏移量 scrollView.contentOffset.y:%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < 0) {
        [self.view endEditing:YES];
    }
    //NSLog(@"scrollViewDidScroll");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 网络请求
//上传图片
- (void)uploadDataWith:(NSString *)str filePath:(NSString *)filePath fileName:(NSString *)fileName{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];;
    _hud.labelText = @"0%";
    _hud.detailsLabelText = @"正在上传";
    _hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    
    
    __weak typeof(self)weakSelf = self;
    if (filePath) {
        NSDictionary *dic = @{@"flag":@"AddDialogue", @"reportid":_model.caseid, @"userid":UDSobjectForKey(USERID), @"content":str, @"file":fileName};
        __weak typeof(self)weakSelf = self;
        [LCAFNetWork uploadWithURL:@"dialogueios" params:dic fileData:[NSData dataWithContentsOfFile:filePath] name:@"upload" fileName:fileName mimeType:@"zip" progress:^(NSProgress *progress) {
            [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"state"] intValue] == 1) {
                if (_blcok) {
                    _blcok();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_hud hide:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            [weakSelf performSelectorInBackground:@selector(emiptyUploadFile) withObject:nil];
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            [weakSelf performSelectorInBackground:@selector(emiptyUploadFile) withObject:nil];
            [weakSelf.view makeToast:error.localizedDescription duration:1.0 position:CSToastPositionCenter];
        }];
        
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.responseSerializer.acceptableContentTypes = manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
//                                                                                                                 @"application/json",
//                                                                                                                 @"application/x-www-form-urlencoded",
//                                                                                                                 @"text/html",
//                                                                                                                 @"image/jpeg",
//                                                                                                                 @"image/png",
//                                                                                                                 @"application/octet-stream",
//                                                                                                                 @"text/json",
//                                                                                                                 nil];
//        // 2.设置请求参数的拼接
//        manager.requestSerializer=[AFJSONRequestSerializer serializer];
//        // 申明请求的数据是json类型
//        manager.requestSerializer=[AFJSONRequestSerializer serializer];
//        [manager POST:[NSString stringWithFormat:@"%@%@", BASEURL,@"dialogue"] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//            [formData appendPartWithFileData:[NSData dataWithContentsOfFile:filePath] name:@"upload" fileName:fileName mimeType:@"zip"];
//        } progress:^(NSProgress * _Nonnull uploadProgress) {
//            [uploadProgress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            if ([responseObject[@"state"] intValue] == 1) {
//                
//                if (_blcok) {
//                    _blcok();
//                }
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [_hud hideAnimated:YES];
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
//            }
//            [weakSelf performSelectorInBackground:@selector(emiptyUploadFile) withObject:nil];
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [weakSelf performSelectorInBackground:@selector(emiptyUploadFile) withObject:nil];
//            [weakSelf.view makeToast:error.localizedDescription duration:1.0 position:CSToastPositionCenter];
//        }];
    }else{
        NSDictionary *dic = @{@"flag":@"AddDialogue", @"reportid":_model.caseid, @"userid":UDSobjectForKey(USERID), @"content":str, @"file":@""};
        // NSLog(@"===========%@", StrFormat(@"%@dialogue", BASEURL));
        [LCAFNetWork POST:@"dialogue" params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"state"] intValue] == 1) {
                if (_blcok) {
                    _blcok();
                }
                [_hud hide:YES];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            [weakSelf.view makeToast:responseObject[MESSAGE] duration:1.0 position:CSToastPositionCenter];
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            [_hud hide:YES];
        }];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //   NSLog(@"3.============%@", [NSDate date]);
    NSProgress *progress = nil;
    if ([object isKindOfClass:[NSProgress class]]) {
        progress = (NSProgress *)object;
    }
    if (progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _hud.progress = progress.fractionCompleted;
            _hud.labelText = [NSString stringWithFormat:@"%.f%%", progress.fractionCompleted * 100];
            if (progress.fractionCompleted == 1) {
                _hud.detailsLabelText = @"上传成功";
            } else {
                _hud.detailsLabelText = @"正在上传";
            }
        });
    }
}

#pragma mark -
- (void)getDataWithDic:(NSDictionary *)dic{
}

/**
 删除存放zip和txt的文本
 */
- (void)emiptyUploadFile{
    [SandBoxManager deleteCacheFileWithPath:@"/uploadzip"];
}

- (void)setleftBarButtonItm{
    self.navigationItem.title = @"意见";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStyleDone) target:self action:@selector(backBefore)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    
    UIBarButtonItem *rightItem= [[UIBarButtonItem alloc] initWithTitle:@"发表意见" style:(UIBarButtonItemStyleDone) target:self action:@selector(submitBtnClicked)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)backBefore{
    [self.navigationController popViewControllerAnimated:YES];
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
