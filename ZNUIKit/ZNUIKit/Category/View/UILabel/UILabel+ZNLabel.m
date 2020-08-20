//
//  UILabel+ZNLabel.m
//  TableViewCollectView
//
//  Created by 郑楠楠 on 2018/4/2.
//  Copyright © 2018年 郑楠楠. All rights reserved.
//

#import "UILabel+ZNLabel.h"
#import "ThreeHeadFile.h"

@implementation UILabel (ZNLabel)

+ (void)load{
    Method originalThodText = class_getInstanceMethod([self class], @selector(setText:));
    Method newThodText = class_getInstanceMethod([self class], @selector(reSetText:));
     method_exchangeImplementations(originalThodText, newThodText);
}

/// 屏蔽 nil的设置存在
/// @param text <#text description#>
- (void)reSetText:(NSString*) text{
    if (text == nil || [text isKindOfClass:[NSNull class]]) {
        text = @"";
    }
    [self reSetText:text];
}

/**
 根据位置进行设置字体以及文字的颜色
 
 @param range <#range description#>
 @param font <#font description#>
 @param color <#color description#>
 */
- (void)zn_setFontAndColorWithRanage:(NSRange) range
                             font:(UIFont *)font
                            color:(UIColor *)color{
    NSAttributedString *text = self.attributedText;
    NSMutableAttributedString *strArr = [[NSMutableAttributedString alloc] initWithAttributedString:text];
    [strArr addAttribute:NSForegroundColorAttributeName value:color range:range];
    [strArr addAttribute:NSFontAttributeName value:font range:range];
    self.attributedText = strArr;
}

/**
 根据字符串进行修改文字颜色字体
 
 @param string <#string description#>
 @param font <#font description#>
 @param color <#color description#>
 */
- (void)zn_setFontAndColorWithString:(NSString *) string
                             font:(UIFont *)font
                            color:(UIColor *)color{
    NSRange range = [self.text rangeOfString:string];
    [self zn_setFontAndColorWithRanage:range font:font color:color];
}

/**
 批量设置字符串的字体
 
 @param arrayStr <#arrayStr description#>
 @param font <#font description#>
 @param color <#color description#>
 */
- (void)zn_setFontAndColorWithArrayStr:(NSArray<NSString*> *) arrayStr
                                  font:(UIFont *)font
                                 color:(UIColor *)color{
    for (NSString * str in arrayStr) {
        [self zn_setFontAndColorWithString:str font:font color:color];
    }
}

/// 设置中划线
- (void)zn_setCenterLine{
    if (self.text) {
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.text attributes:attribtDic];
        // 赋值
        self.attributedText = attribtStr;
    }
}

- (void)zn_setCenterLineWithString:(NSString *) text{
    if (self.text) {
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        NSRange range = [self.text rangeOfString:text];
        
        //中划线
        [attribtStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
        // 赋值
        self.attributedText = attribtStr;
    }
}

/// 改变行距
/// @param lable <#lable description#>
/// @param space <#space description#>
+ (void)zn_changeLineSpaceforLable:(UILabel *)lable WithSpace:(float)space{
    NSString * labletext =lable.text;
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:labletext];
    NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labletext length])];
    [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(0) range:NSMakeRange(0, [labletext length])];
    lable.attributedText = attributedString;
    [lable sizeToFit];
}

/// 改变字间距
/// @param lable <#lable description#>
/// @param space <#space description#>
+ (void)zn_changeWordSpaceForLabel:(UILabel *)lable WithSpace:(float)space{
    NSString * lableText = lable.text;
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:lableText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [lableText length])];
    [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(0) range:NSMakeRange(0, [lableText length])];
    lable.attributedText = attributedString;
    [lable sizeToFit];
}

/// 改变字行 间距
/// @param lable <#lable description#>
/// @param linkspace <#linkspace description#>
/// @param wordspace <#wordspace description#>
+ (void)zn_changeSpaceForLable:(UILabel *)lable withLineSpace:(float)linkspace WordSpace:(float)wordspace{
    NSString * labletext= lable.text;
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:labletext];
    NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setLineSpacing:linkspace];
    [attributedString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@(wordspace)} range:NSMakeRange(0, [labletext length])];
    [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(0) range:NSMakeRange(0, [labletext length])];
    lable.attributedText = attributedString;
    [lable sizeToFit];
}

@end
