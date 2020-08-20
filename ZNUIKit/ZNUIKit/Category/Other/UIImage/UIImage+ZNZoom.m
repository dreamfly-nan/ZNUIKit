//
//  UIImage+ZNZoom.m
//  ZNUIKit
//
//  Created by 郑楠楠 on 2020/7/24.
//  Copyright © 2020 郑楠楠. All rights reserved.
//

#import "UIImage+ZNZoom.h"

@implementation UIImage (ZNZoom)

/**
 图片缩放
 
 @param size 要缩放的大小
 @return <#return value description#>
 */
- (UIImage *)zn_zoomWithSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) *0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) *0.5;
        }
        
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [self drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
        return self;
    }
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 根据宽进行缩放
 
 @param width <#width description#>
 @return <#return value description#>
 */
- (UIImage *)zn_zoomWithWidth:(CGFloat)width{
    return [self zn_zoomWithSize:CGSizeMake(width, width / self.size.width * self.size.height)];
}

/**
 根据高比例进行缩放
 @param height <#width description#>
 @return <#return value description#>
 */
- (UIImage *)zn_zoomWithHeight:(CGFloat)height{
    return [self zn_zoomWithSize:CGSizeMake(height / self.size.height * self.size.width, height)];
}

/**
 对图标按一定标准进行缩放操作,按长宽中的最大值跟standard的比重进行缩放
 @param standard 缩放的标准值，（就是正方形的边长）
 @return 缩放后的图片
 */
- (UIImage*)zn_zoomStandard:(CGFloat) standard{
    CGFloat sizeNumber = 1;
    CGFloat max = self.size.height > self.size.width ? self.size.height : self.size.width;
    CGFloat min = self.size.height > self.size.width ? self.size.width : self.size.height;
    if (max > standard) {
        sizeNumber = standard / max;
    }else{
        if (min < standard) {
            sizeNumber = standard / min;
        }
    }
    CGSize size = CGSizeMake(sizeNumber * self.size.width, sizeNumber * self.size.height);
    return [self zn_zoomWithSize:size];
}


@end
