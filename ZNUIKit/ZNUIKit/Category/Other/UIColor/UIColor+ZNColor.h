//
//  UIColor+ZNColor.h
//  TableViewCollectView
//
//  Created by 郑楠楠 on 2018/4/3.
//  Copyright © 2018年 郑楠楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZNColor)

/**
 十六进制字符串 这样的形式 @"#6cabdf"

 @param color <#color description#>
 @return <#return value description#>
 */
+ (UIColor *) zn_colorWithHexString: (NSString *)color;


///  十六进制字符串 这样的形式 @"#333333FF"
/// @param hexColor <#hexColor description#>
+(UIColor *)zn_getSixteenToRGBColor:(NSString *)hexColor;


/// 生成渐变色
/// @param startColor 起始色
/// @param endColor 结束色
/// @param percent 渐变比率
+(UIColor *) createGradualColorByStartColor:(UIColor *) startColor EndColor:(UIColor *) endColor offSetPercent:(CGFloat) percent;

@end
