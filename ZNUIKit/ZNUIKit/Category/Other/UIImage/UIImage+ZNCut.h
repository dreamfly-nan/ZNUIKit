//
//  UIImage+ZNCut.h
//  ZNUIKit
//
//  Created by 郑楠楠 on 2020/7/24.
//  Copyright © 2020 郑楠楠. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZNCut)

/**
 裁剪图片,裁剪出来的是矩形的
 
 @param rect 裁剪的左上角坐标，及其要裁剪的大小
 @return <#return value description#>
 */
- (UIImage *)zn_cutImageWithRect:(CGRect)rect;

/**
 裁剪图片，按图片的中心点进行裁剪，裁剪出来的是矩形的
 
 @param size 裁剪出来的图片大小
 @return <#return value description#>
 */
- (UIImage *)zn_cutImageWithSize:(CGSize)size;

/**
 裁剪圆形图片
 @param point 圆心
 @param corcon 圆的半径
 @return <#return value description#>
 */
- (UIImage *)zn_cutRoundWithPoint:(CGPoint)point
                           corcon:(CGFloat)corcon;

/**
 按该图片的最大半径进行裁剪，裁剪出来的图片是靠上进行裁剪，即图片的上端是原图片上端
 
 @return <#return value description#>
 */
- (UIImage *)zn_cutRound;

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+ (UIImage *)zn_cutImageFromImage:(UIImage *)image inRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
