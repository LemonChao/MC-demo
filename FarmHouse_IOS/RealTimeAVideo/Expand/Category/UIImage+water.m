//
//  UIImage+water.m
//  WaterImage
//
//  Created by Lemon on 17/1/12.
//  Copyright © 2017年 LemonChao. All rights reserved.
//

#import "UIImage+water.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (water)


- (UIImage *)imageWater:(UIImage *)imageLogo txtArray:(NSMutableArray *)txtArray
{
    //    CGImageRef inputCGImage = [self CGImage];
    //    NSUInteger inputWidth = CGImageGetWidth(inputCGImage);
    //    NSUInteger inputHeight = CGImageGetHeight(inputCGImage);
    
    //背景图片宽高
    CGFloat inputWidth = self.size.width;
    CGFloat inputHeight = self.size.height;
    
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context 5S:{2448, 3264}
    UIGraphicsBeginImageContext(self.size);
    NSLog(@"%lf,%lf",inputWidth,inputHeight);
    //    开始图片渲染
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    //    logo渲染
    CGFloat ghostImageAspectRatio = imageLogo.size.width / imageLogo.size.height;
    CGFloat logoWidth = inputWidth * 0.2;//0.25
    CGFloat logoHeight= logoWidth/ghostImageAspectRatio;
    [imageLogo drawInRect:CGRectMake(0, 0, logoWidth, logoHeight)];
    
    //    渲染文字
    CGFloat wordHigh = logoHeight / 4.;
    CGFloat wordWidth = inputWidth *0.8;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:wordHigh - 5], NSForegroundColorAttributeName:[UIColor redColor], NSParagraphStyleAttributeName:paragraphStyle};
    
    int i = 0;
    for (NSString *waterStr in txtArray) {
        [waterStr drawInRect:CGRectMake(logoWidth, wordHigh*i, wordWidth, wordHigh) withAttributes:dic];
        i++;
    }
    
    
    //    UIImage
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return imageNew;
}


- (UIImage*)imageWaterMarkWithImage:(UIImage *)image imageRect:(CGRect)imgRect alpha:(CGFloat)alpha
{
    return [self imageWaterMarkWithString:nil rect:CGRectZero attribute:nil image:image imageRect:imgRect alpha:alpha];
}

- (UIImage*)imageWaterMarkWithImage:(UIImage*)image imagePoint:(CGPoint)imgPoint alpha:(CGFloat)alpha
{
    return [self imageWaterMarkWithString:nil point:CGPointZero attribute:nil image:image imagePoint:imgPoint alpha:alpha];
}

- (UIImage*)imageWaterMarkWithString:(NSString*)str rect:(CGRect)strRect attribute:(NSDictionary *)attri
{
    return [self imageWaterMarkWithString:str rect:strRect attribute:attri image:nil imageRect:CGRectZero alpha:0];
}

- (UIImage*)imageWaterMarkWithString:(NSString*)str point:(CGPoint)strPoint attribute:(NSDictionary*)attri
{
    return [self imageWaterMarkWithString:str point:strPoint attribute:attri image:nil imagePoint:CGPointZero alpha:0];
}

- (UIImage*)imageWaterMarkWithString:(NSString*)str point:(CGPoint)strPoint attribute:(NSDictionary*)attri image:(UIImage*)image imagePoint:(CGPoint)imgPoint alpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContext(self.size);
    [self drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeNormal alpha:1.0];
    if (image) {
        [image drawAtPoint:imgPoint blendMode:kCGBlendModeNormal alpha:alpha];
    }
    
    if (str) {
        [str drawAtPoint:strPoint withAttributes:attri];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
    
}

- (UIImage*)imageWaterMarkWithString:(NSString*)str rect:(CGRect)strRect attribute:(NSDictionary *)attri image:(UIImage *)image imageRect:(CGRect)imgRect alpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    if (image) {
        [image drawInRect:imgRect blendMode:kCGBlendModeNormal alpha:alpha];
    }
    
    if (str) {
        [str drawInRect:strRect withAttributes:attri];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}


//
-(UIImage *)addText:(UIImage *)img text:(NSString *)text1
{
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    
    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);
    char* text = (char *)[text1 cStringUsingEncoding:NSUTF8StringEncoding];
    CGContextSelectFont(context, "Georgia", 100, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 255, 0, 0, 1);
    CGContextShowTextAtPoint(context, w/2-strlen(text)*5, h/2, text, strlen(text));
    //Create image ref from the context
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}


@end
