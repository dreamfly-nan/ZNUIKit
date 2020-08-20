//
//  UIColor+ZNColor.m
//  TableViewCollectView
//
//  Created by 郑楠楠 on 2018/4/3.
//  Copyright © 2018年 郑楠楠. All rights reserved.
//

#import "UIColor+ZNColor.h"
#import <YYKit/YYKit.h>

@implementation UIColor (ZNColor)

+ (UIColor *) zn_colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+(UIColor *)zn_getSixteenToRGBColor:(NSString *)hexColor {
//    [self getSixteenToRGBColor:@"#1B9E5CFF"];//
    unsigned int red,green,blue,aphex;
    hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
   
    if (hexColor.length>=6) {
        NSRange range;
        range.length    = 2;
        
        range.location  = 0;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
        range.location  = 2;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
        range.location  = 4;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
        
        aphex           = 1;
        
        if (hexColor.length==8) {
            range.location  = 6;
            [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&aphex];
        }
        
        return [UIColor colorWithRed:((float) red / 255.0f) green:((float) green / 255.0f) blue:((float) blue / 255.0f) alpha:((float)aphex / 255.0f)];
    }else{
        
        return  UIColor.whiteColor;
    }
}

+(UIColor *) createGradualColorByStartColor:(UIColor *) startColor EndColor:(UIColor *) endColor offSetPercent:(CGFloat) percent {

    CGFloat red = [self interpolationFrom:startColor.red to:endColor.red percent:percent];
    CGFloat green = [self interpolationFrom:startColor.green to:endColor.green percent:percent];
    CGFloat blue = [self interpolationFrom:startColor.blue to:endColor.blue percent:percent];
    CGFloat alpha = [self interpolationFrom:startColor.alpha to:endColor.alpha percent:percent];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent
{
    percent = MAX(0, MIN(1, percent));
    return from + (to - from)*percent;
}


@end
