//
//  UIImage+ZNImage.h
//  TableViewCollectView
//
//  Created by 郑楠楠 on 2018/4/20.
//  Copyright © 2018年 郑楠楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZNImage)

/**
 获取图片的主色调
 
 @return <#return value description#>
 */
- (UIColor *)zn_obtainMainColor;

/// 根据URL获取图片
/// @param url <#url description#>
+ (void)zn_obtainImageWithUrl:(NSString*) url
                        block:(void (^)(UIImage * image)) block;

//根据图片链接获取图片的size
+(CGSize)getImageSizeWithURL:(id)imageURL;

//根据图片链接以及图片控件宽度进行等比例缩放获取图片的高度
+(float)getImageHeightWithUrl:(id)imageURL
                   imageWidth:(float)width;

@end
