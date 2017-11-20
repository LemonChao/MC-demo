//
//  LCTools.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/15.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCTools.h"

@implementation LCTools
{
    NSTimer *timer;
    NSDate *pauseStart;
    NSDate *previousFireDate;
    NSInteger isRun;
}


+ (BOOL)checkData:(id)obj
{
    return [obj isKindOfClass:[NSDictionary class]] ? YES : NO;
}


+ (NSString *)encodeMobile:(NSString *)mobilePhone
{
    if (mobilePhone.length > 7) {
        return [mobilePhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    return @"";
}
+ (void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",@"ABC", nil];
    [alert show];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeAlert:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert, @"alert", nil] repeats:NO];
}

+ (void)removeAlert:(NSTimer *)timer
{
    UIAlertView *alert = (UIAlertView *)[timer.userInfo objectForKey:@"alert"];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [timer invalidate];
    timer = nil;
}
+(UIView *)headerView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 9, SCREEN_WIDTH, 1)];
    [view addSubview:bottomLine];
    view.backgroundColor = [UIColor colorwithHexString:@"#F0F0F0"];
    bottomLine.backgroundColor = [UIColor colorwithHexString:@"#EEEEEE"];
    return view;
}
//创建Label
+(UILabel*)createLable:(NSString *)name
              withFont:(UIFont*)font
             textColor:(UIColor*)textColor
         textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *lable = [[UILabel alloc] init];
    if(!name)
    {
        lable.text = @"";
    }
    else
    {
        lable.text = name;
    }
    lable.textColor = [UIColor blackColor];
    lable.font = font;
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = textColor;
    lable.textAlignment = textAlignment;
    lable.numberOfLines = 0;
    return lable;
}
+(UILabel*)createLable:(CGRect)frame
              withName:(NSString *)name
              withFont:(CGFloat)font
{
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    if(!name)
    {
        lable.text = @"";
    }
    else
    {
        lable.text = name;
    }
    lable.textColor = [UIColor blackColor];
    lable.font = [UIFont systemFontOfSize:font];
    lable.backgroundColor = [UIColor clearColor];
    lable.numberOfLines = 0;
    return lable;
}

//创建圆角文字button nolmal
+(UIButton*)createWordButton:(UIButtonType)type
                       title:(NSString*)title
                  titleColor:(UIColor*)titleColor
                        font:(UIFont*)font
                     bgColor:(UIColor*)bgColor
                cornerRadius:(CGFloat)cornerRadius
                 borderColor:(UIColor*)borderColor
                 borderWidth:(CGFloat)borderWidth
{
    UIButton *button = [self createWordButton:type
                                        title:title
                                   titleColor:titleColor
                                         font:font
                                      bgColor:bgColor];
    if (cornerRadius != 0) {
        button.layer.cornerRadius = cornerRadius;
        button.layer.borderColor = borderColor.CGColor;
        button.layer.borderWidth = borderWidth;
        button.clipsToBounds = YES;
    }
    
    return button;
}

//创建直角文字button nolmal
+(UIButton*)createWordButton:(UIButtonType)type
                      title:(NSString*)title
                 titleColor:(UIColor*)titleColor
                       font:(UIFont*)font
                    bgColor:(UIColor*)bgColor
{
    UIButton *button = [UIButton buttonWithType:type];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.backgroundColor = bgColor;
    
    return button;
}
//创建Button
+(UIButton*)createButton:(CGRect)frame
               withName:(NSString*)name
              normalImg:(UIImage*)normalImg
           highlightImg:(UIImage*)highlightImg
              selectImg:(UIImage*)selectImg
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    if(!name)
    {
        [button setTitle:@"" forState:UIControlStateNormal];
    }
    else
    {
        [button setTitle:name forState:UIControlStateNormal];
    }
    [button setBackgroundImage:normalImg forState:UIControlStateNormal];
    [button setBackgroundImage:selectImg forState:UIControlStateSelected];
    [button setBackgroundImage:highlightImg forState:UIControlStateHighlighted];
    return button;
}
//创建TextField
+ (UITextField *)createTextField:(CGRect)frame
                 withPlaceholder:(NSString *)placeholder
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:14];
    return textField;
}
+ (UITextField *)createTextField:(UIFont*)font
                     borderStyle:(UITextBorderStyle)borderStyle
                 withPlaceholder:(NSString *)placeholder
{
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = borderStyle;
    textField.placeholder = placeholder;
    textField.font = font;
    return textField;
}

//创建Label
+ (UITableView *)createTableView:(CGRect)frame
                    withDelegate:(id)delegate
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    return tableView;
}
//创建圆角图片
+ (UIImageView *)createImageView:(UIImage *)image
                    cornerRadius:(CGFloat)cornerRadius
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:image];
    
    imageView.layer.cornerRadius = cornerRadius;
    imageView.layer.borderWidth = 1;
    imageView.layer.borderColor = [UIColor clearColor].CGColor;
    imageView.layer.masksToBounds = YES;
    return imageView;
}

+ (UIImageView *)createImageView:(CGRect)frame
                             url:(NSURL*)url
                     placeHolder:(UIImage *)image
                    cornerRadius:(CGFloat)cornerRadius
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView sd_setImageWithURL:url placeholderImage:image];
    
    imageView.layer.cornerRadius = cornerRadius;
    imageView.layer.borderWidth = 1;
    imageView.layer.borderColor = [UIColor clearColor].CGColor;
    imageView.layer.masksToBounds = YES;
    return imageView;
}

//masonry 约束布局指定frame也没用
+ (UIImageView *)createImageView:(NSURL*)url
                     placeHolder:(UIImage *)image
                    cornerRadius:(CGFloat)cornerRadius
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:url placeholderImage:image];
    
    imageView.layer.cornerRadius = cornerRadius;
    imageView.layer.borderWidth = 1;
    imageView.layer.borderColor = [UIColor clearColor].CGColor;
    imageView.layer.masksToBounds = YES;
    return imageView;
}
//创建scrollerView
+ (UIScrollView *)createScrollView:(CGRect)frame
                      withDelegate:(id)delegate
                   withContentSize:(CGSize)contentSize
{
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:frame];
    scrollview.contentSize = contentSize;
    scrollview.delegate = delegate;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.pagingEnabled = YES;
    scrollview.bounces = NO;
    return scrollview;
}

/**
 横线
 */
+ (UIView *)createLineView:(UIColor *)color {
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = color;
    return line;
}
#pragma mark --计算Lable高度
+ (CGFloat)heightWithString:(NSString *)string
                       font:(UIFont *)font
         constrainedToWidth:(CGFloat)width
{
    CGSize tempSize = CGSizeMake(width, MAXFLOAT);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [string boundingRectWithSize:tempSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return size.height;
}


#pragma mark --  Lable单行文字宽度
+ (CGFloat)widthWithString:(NSString *)string
                      font:(UIFont *)font
{
    CGSize contentSize = [string sizeWithAttributes:@{NSFontAttributeName:font}];
    return contentSize.width;

}
#pragma mark -- 弹框
+ (void)showNetFail
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:@"数据加载失败,请检查网络重新加载"
                                                   delegate:self
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark 等比压缩图片
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}
#pragma mark -- image的翻转
+ (UIImage *)rotateImage:(UIImage *)aImage
{
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = aImage.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            break;
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,181,189
     NSString * MOBILES = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
     */
    
    
    NSString * MOBILES = @"1[0-9]{10}";//1开头 11 位
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278]|47|7[0-8])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56]|7[6])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,181,189
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILES];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+ (BOOL)isMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,181,189
     */
    
    /*
     130，131，……139；
     145，147，
     150，152，153，155，156，……159 （没有154）
     170
     180，181，……189
     */
    
    
    //    NSString * MOBILES = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString *M1 = @"1[0-9]{10}";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", M1];
    
    
    if ([regextestmobile evaluateWithObject:mobileNum] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)checkIOSSettingReview
{
    //    return YES;
    //开关
    NSNumber *number = [[NSUserDefaults standardUserDefaults]objectForKey:@"checkIosKeyzz"];
    DLog(@"%@",number);
    if (number)
    {
        if (number.integerValue == 1)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isIdCardValidation:(NSString *)identityCard
{
    //    BOOL flag;
    if (identityCard.length <= 0)
    {
        return NO;
    }
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //    flag = [identityCardPredicate evaluateWithObject:identityCard];
    
    
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if([identityCardPredicate evaluateWithObject:identityCard])
    {
        if(identityCard.length==18)
        {
            //将前17位加权因子保存在数组里
            NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
            
            //这是除以11后，可能产生的11位余数、验证码，也保存成数组
            NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
            
            //用来保存前17位各自乖以加权因子后的总和
            
            NSInteger idCardWiSum = 0;
            for(int i = 0;i < 17;i++)
            {
                NSInteger subStrIndex = [[identityCard substringWithRange:NSMakeRange(i, 1)] integerValue];
                NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
                
                idCardWiSum+= subStrIndex * idCardWiIndex;
                
            }
            
            //计算出校验码所在数组的位置
            NSInteger idCardMod=idCardWiSum%11;
            
            //得到最后一位身份证号码
            NSString * idCardLast= [identityCard substringWithRange:NSMakeRange(17, 1)];
            
            //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
            if(idCardMod==2)
            {
                if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
                {
                    return YES;
                }else
                {
                    return NO;
                }
            }else
            {
                //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
                {
                    return YES;
                }
                else
                {
                    return NO;
                }
            }
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isInputCorrect:(NSString *)input
{
    NSString *strInput = [input stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (input.length == 0 || strInput.length == 0) {
        return NO;
    } else {
        return YES;
    }
}
/**
 创建单像素的的线条
 */
+ (UIImageView *)createImgLine:(CGRect)frame;
{
    UIImageView *imgCross = [[UIImageView alloc] initWithFrame:frame];
    imgCross.backgroundColor = [UIColor colorwithHexString:@"#EEEEEE"];
    return imgCross;
}

//生成纯色图片的函数
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
//设置状态栏颜色
+ (void)statusWithStyle:(UIStatusBarStyle)style
{
    [[UIApplication sharedApplication] setStatusBarStyle:style];
}

+ (void)getLayoutHeight:(UIView *)view
{
    //  强制布局之前，需要先手动设置下cell的真实宽度，以便于准确计算
    CGRect rect = view.frame;
    rect.size.width = [[UIScreen mainScreen] bounds].size.width;
    view.frame = rect;
    [view layoutIfNeeded];    //  一定要强制布局下，否则拿到的高度不准确
}

+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    shapeLayer.strokeColor = lineColor.CGColor;
    
    shapeLayer.fillColor = nil;
    
    shapeLayer.path = [UIBezierPath bezierPathWithRect:lineView.bounds].CGPath;
    
    
    shapeLayer.lineWidth = 1.5f;
    
    shapeLayer.lineCap = @"square";
    
    shapeLayer.lineDashPattern = @[@4, @2];
    
    
    [lineView.layer addSublayer:shapeLayer];
}



- (instancetype)initTimerInterval:(NSTimeInterval)ts WithTarget:(id)target selector:(nonnull SEL)sel repeats:(BOOL)repeats {
    
    self = [super init];
    if (self) {
        timer = [NSTimer scheduledTimerWithTimeInterval:ts target:target selector:sel userInfo:nil repeats:repeats];
        isRun = YES;
    }
    return self;
}


- (void)freeNSTimer {
    [timer invalidate];
}

- (void)pauseTimer {
    
    if (!isRun) return;
    
    pauseStart = [NSDate dateWithTimeIntervalSinceNow:0];
    previousFireDate = [timer fireDate];
    [timer setFireDate:[NSDate distantFuture]];
    isRun = NO;
    
}

- (void)startTimer {
    
    if (isRun) return;
    
    float pauseTime = -1*[pauseStart timeIntervalSinceNow];
    [timer setFireDate:[NSDate dateWithTimeInterval:pauseTime sinceDate:previousFireDate]];
    isRun = YES;
    
}

- (void)dealloc
{
    NSLog(@"%@ dealoc", [self class]);
}

@end
