//
//  UIImage+NNTool.h
//  GameGuestVidio
//
//  Created by 郑楠楠 on 2017/12/1.
//  Copyright © 2017年 郑楠楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZNTool)

/** 取图片某一像素的颜色 */
- (UIColor *)zn_colorWithAtPixel:(CGPoint)point;

/** 获得灰度图 */
- (UIImage *)zn_convertToGrayImage;

#pragma mark --------旋转
/**
 *  得到旋转后的图片
 *
 *  @param Angle 角度（0~360）
 *
 *  @return 新生成的图片
 */
-(UIImage  *)zn_getRotationAngle:(CGFloat)Angle;

// 照相机图片旋转

+ (UIImage *)zn_fixOrientation:(UIImage *)aImage;

@end
