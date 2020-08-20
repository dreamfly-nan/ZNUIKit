//
//  UIImage+ZNCut.m
//  ZNUIKit
//
//  Created by 郑楠楠 on 2020/7/24.
//  Copyright © 2020 郑楠楠. All rights reserved.
//

#import "UIImage+ZNCut.h"

@implementation UIImage (ZNCut)

/**
 裁剪图片,裁剪出来的是矩形的
 
 @param rect 裁剪的左上角坐标，及其要裁剪的大小
 @return <#return value description#>
 */
- (UIImage *)zn_cutImageWithRect:(CGRect)rect{
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [self CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newImage;
}

/**
 裁剪图片，按图片的中心点进行裁剪，裁剪出来的是矩形的
 
 @param size 裁剪出来的图片大小
 @return <#return value description#>
 */
- (UIImage *)zn_cutImageWithSize:(CGSize)size{
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGSize imageSize = self.size;
    
    return [self zn_cutImageWithRect:CGRectMake(imageSize.width/2 - width, imageSize.height/2 - height, width, height)];
}

/**
 裁剪圆形图片
 
 @param point 圆心
 @param corcon 圆的半径
 @return <#return value description#>
 */
- (UIImage *)zn_cutRoundWithPoint:(CGPoint)point
                           corcon:(CGFloat)corcon{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillPath(context);
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(point.x, point.y, self.size.width - corcon * 2.0f, self.size.height - corcon * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    [self drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

/**
 按该图片的最大半径进行裁剪，裁剪出来的图片是靠上进行裁剪，即图片的上端是原图片上端
 
 @return <#return value description#>
 */
- (UIImage *)zn_cutRound{
    CGFloat corcon = self.size.width > self.size.height ? self.size.height : self.size.width;
    corcon = corcon / 2;
    return [self zn_cutRoundWithPoint:CGPointMake(corcon, corcon) corcon:corcon];
}

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+ (UIImage *)zn_cutImageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newImage;
}

@end
