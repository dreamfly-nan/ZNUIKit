//
//  UIImage+ZNZoom.h
//  ZNUIKit
//
//  Created by 郑楠楠 on 2020/7/24.
//  Copyright © 2020 郑楠楠. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZNZoom)

/**
 图片缩放
 @param size 要缩放的大小
 @return <#return value description#>
 */
- (UIImage *)zn_zoomWithSize:(CGSize)size;

/**
 根据宽比例进行缩放
 @param width <#width description#>
 @return <#return value description#>
 */
- (UIImage *)zn_zoomWithWidth:(CGFloat)width;

/**
 根据高比例进行缩放
 @param height <#width description#>
 @return <#return value description#>
 */
- (UIImage *)zn_zoomWithHeight:(CGFloat)height;

/**
 对图标按一定标准进行缩放操作
 @param standard 缩放的标准值，（就是正方形的边长）
 @return 缩放后的图片
 */
- (UIImage*)zn_zoomStandard:(CGFloat) standard;

@end

NS_ASSUME_NONNULL_END
