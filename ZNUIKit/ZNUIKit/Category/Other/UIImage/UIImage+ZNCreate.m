//
//  UIImage+ZNCreate.m
//  JokeContent
//
//  Created by 南木南木 on 2019/7/4.
//  Copyright © 2019 南木南木. All rights reserved.
//

#import "UIImage+ZNCreate.h"
#import <SDImageCache.h>

@implementation UIImage (ZNCreate)

/**
 获取文件中的图片，返回UIImage对象
 
 @param name 文件名
 @param type 文件类型
 @return <#return value description#>
 */
+ (UIImage*)zn_createWithFileName:(NSString*) name
                             type:(NSString*) type{
   NSString * path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    return [UIImage imageWithContentsOfFile:path];
}

/**
 根据url获取图片
 
 @param url <#url description#>
 @param block <#block description#>
 */
+ (void)zn_createWithLocationUrl:(NSString*) url
                           block:(void (^)(UIImage * image)) block{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (block) {
        block([UIImage imageWithData:data]);
    }
}

/**
 使用这个方法获取到的截图，图片文字都会变模糊
 
 @param view 需要截图的view
 @return <#return value description#>
 */
+ (UIImage *)zn_createImageVagueWithView:(UIView *) view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 使用该方法生成的图片不会模糊，根据屏幕密度计算
 
 @param view 需要截图的view
 @return <#return value description#>
 */
+ (UIImage *)zn_createImageWithView:(UIView *) view{
    UIImage *imageRet = [[UIImage alloc]init];
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageRet;
}

/**
 根据指定的颜色生成一张指定大小的纯色图片
 
 @param color 颜色
 @param size 大小
 @return 一张图片
 */
+ (UIImage *)zn_createImageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 根据颜色生成纯色图片 */
+ (UIImage *)zn_createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 根据CIImage对象生成UIImage对象
 
 @param image ciimage对象
 @param size 生成的图片大小
 @return 生成的图片
 */
+ (UIImage *) zn_createImageWithCIImage:(CIImage *)image withSize:(CGSize)size
{
    if (image) {
        CGRect extent = CGRectIntegral(image.extent);
        CGFloat scaleWidth = size.width/CGRectGetWidth(extent);
        CGFloat scaleHeight = size.height/CGRectGetHeight(extent);
        size_t width = CGRectGetWidth(extent) * scaleWidth;
        size_t height = CGRectGetHeight(extent) * scaleHeight;
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
        CGContextRef contentRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef imageRef = [context createCGImage:image fromRect:extent];
        CGContextSetInterpolationQuality(contentRef, kCGInterpolationNone);
        CGContextScaleCTM(contentRef, scaleWidth, scaleHeight);
        CGContextDrawImage(contentRef, extent, imageRef);
        CGImageRef imageRefResized = CGBitmapContextCreateImage(contentRef);
        CGContextRelease(contentRef);
        CGImageRelease(imageRef);
        return [UIImage imageWithCGImage:imageRefResized];
    }else{
        return nil;
    }
}

/**
 图片组合 网络请求，使用SD缓存到本地磁盘，请求前先去缓存中哈希查找是否有缓存
 
 @param URLArray 图片url 数组
 @param corner 新生成组合图片背景圆角
 @param bgColor 新生成组合图片背景颜色
 @param Success 组合成功回调
 @param Failed 组合失败回调
 */
+(void)zn_createGroupIconWithURLArray:(NSArray *)URLArray
                      corner:(CGFloat)corner
                     bgColor:(UIColor *)bgColor
                     Success:(void(^)(UIImage *image))Success
                      Failed:(void(^)(NSString *fail))Failed
{
    UIImage *cacheImage;
    
    NSString *cacheKey = [URLArray componentsJoinedByString:@"-"];
    
    
    SDImageCache * cache = [SDImageCache sharedImageCache];
    //此方法会先从memory中取。
    cacheImage = [cache imageFromDiskCacheForKey:cacheKey];
    
    if (cacheImage) {
        if (Success) {
            Success(cacheImage);
        }
        return;
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    NSMutableArray *imageArray = [NSMutableArray array];
    
    dispatch_group_t g = dispatch_group_create();
    dispatch_queue_t globalQueue=dispatch_get_global_queue(0, 0);
    
    //3.添加任务,让队列调度,任务执行情况,最后通知调度组
    for (int i = 0; i<URLArray.count;  i++) {
        NSURL *url = [NSURL URLWithString:URLArray[i]];
        //请求
        dispatch_group_enter(g);
        dispatch_group_async(g, globalQueue, ^{
            NSLog(@"task %d%@",i,[NSThread currentThread]);
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                [imageArray addObject:image];
            }else{
                [imageArray addObject:[UIImage imageNamed:@"dr_placeholder_avatar_icon"]];
            }
            dispatch_group_leave(g);
        });
    }
    //4.所有任务执行完毕后,通知调度组
    //用一个调度组,可以监听全局队列的任务,主队列去执行最后的任务
    //dispatch_group_notify 本身也是异步的!
    dispatch_group_notify(g, dispatch_get_main_queue(), ^{
        //更新UI,通知用户
        //        NSLog(@"OK更新UI,通知用户 %@",[NSThread currentThread]);
        imageView.image = [UIImage zn_createGroupIconWith:imageArray corner:corner bgColor:[UIColor groupTableViewBackgroundColor]];
        [[SDImageCache sharedImageCache] storeImage:imageView.image forKey:cacheKey toDisk:YES completion:^{
            NSLog(@"缓存图片成功%@",[NSThread currentThread]);
        }];
        
        if (Success) {
            Success(imageView.image);
        }
        if (Failed) {
            Failed(@"头像下载失败");
        }
    });
    //    NSLog(@"come %@", [NSThread currentThread]);
}

+ (void)zn_createGroupIconWithURLArray:(NSArray *)URLArray
                      bgColor:(UIColor *)bgColor
                      Success:(void(^)(UIImage *image))Success
                       Failed:(void(^)(NSString *fail))Failed
{
    
    UIImage *cacheImage;
    
    NSString *cacheKey = [URLArray componentsJoinedByString:@"-"];
    
    SDImageCache* cache = [SDImageCache sharedImageCache];
    //此方法会先从memory中取。
    cacheImage = [cache imageFromDiskCacheForKey:cacheKey];
    
    if (cacheImage) {
        if (Success) {
            Success(cacheImage);
        }
        return;
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    NSMutableArray *imageArray = [NSMutableArray array];
    
    dispatch_group_t g = dispatch_group_create();
    dispatch_queue_t globalQueue=dispatch_get_global_queue(0, 0);
    //3.添加任务,让队列调度,任务执行情况,最后通知调度组
    for (int i = 0; i<URLArray.count;  i++) {
        NSURL *url = [NSURL URLWithString:URLArray[i]];
        //请求
        dispatch_group_enter(g);
        dispatch_group_async(g, globalQueue, ^{
            NSLog(@"task %d%@",i,[NSThread currentThread]);
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                [imageArray addObject:image];
            }else{
                [imageArray addObject:[UIImage imageNamed:@"dr_placeholder_avatar_icon"]];
            }
            dispatch_group_leave(g);
        });
    }
    //4.所有任务执行完毕后,通知调度组
    //用一个调度组,可以监听全局队列的任务,主队列去执行最后的任务
    //dispatch_group_notify 本身也是异步的!
    dispatch_group_notify(g, dispatch_get_main_queue(), ^{
        //更新UI,通知用户
        //        NSLog(@"OK更新UI,通知用户 %@",[NSThread currentThread]);
        imageView.image = [UIImage zn_crateGroupIconWith:imageArray bgColor:[UIColor groupTableViewBackgroundColor]];
        [[SDImageCache sharedImageCache] storeImage:imageView.image forKey:cacheKey toDisk:YES completion:^{
            NSLog(@"缓存图片成功%@",[NSThread currentThread]);
        }];
        
        if (Success) {
            Success(imageView.image);
        }
        if (Failed) {
            Failed(@"头像下载失败");
        }
    });
    //    NSLog(@"come %@", [NSThread currentThread]);
}

+ (UIImage *)zn_crateGroupIconWith:(NSArray *)array bgColor:(UIColor *)bgColor {
    
    CGSize finalSize = CGSizeMake(100, 100);
    CGRect rect = CGRectZero;
    rect.size = finalSize;
    
    UIGraphicsBeginImageContext(finalSize);
    
    if (bgColor) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, bgColor.CGColor);
        CGContextSetFillColorWithColor(context, bgColor.CGColor);
        CGContextSetLineWidth(context, 1.0);
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, 0, 100);
        CGContextAddLineToPoint(context, 100, 100);
        CGContextAddLineToPoint(context, 100, 0);
        CGContextAddLineToPoint(context, 0, 0);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
    if (array.count >= 2) {
        
        NSArray *rects = [self zn_eachRectInGroupWithCount2:array.count];
        int count = 0;
        for (id obj in array) {
            
            if (count > rects.count-1) {
                break;
            }
            
            UIImage *image;
            
            if ([obj isKindOfClass:[NSString class]]) {
                image = [UIImage imageNamed:(NSString *)obj];
            } else if ([obj isKindOfClass:[UIImage class]]){
                image = (UIImage *)obj;
            } else {
                NSLog(@"%s Unrecognizable class type", __FUNCTION__);
                break;
            }
            
            CGRect rect = CGRectFromString([rects objectAtIndex:count]);
            [image drawInRect:rect];
            count++;
        }
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)zn_createGroupIconWith:(NSArray *)array corner:(CGFloat)cornerRadius bgColor:(UIColor *)bgColor {
    
    CGSize finalSize = CGSizeMake(100, 100);
    CGRect rect = CGRectZero;
    rect.size = finalSize;
    
    UIGraphicsBeginImageContext(finalSize);
    
    if (bgColor) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, bgColor.CGColor);
        CGContextSetFillColorWithColor(context, bgColor.CGColor);
        /*画圆角矩形*/
        CGSize rectSize = finalSize;
        CGContextMoveToPoint(context, rectSize.width, cornerRadius * 2);  // 开始坐标右边开始
        CGContextAddArcToPoint(context, rectSize.width, rectSize.height, rectSize.width - 10, rectSize.height, cornerRadius);  // 右下角
        CGContextAddArcToPoint(context, 0, rectSize.height, 0, rectSize.height - 10, cornerRadius); // 左下角
        CGContextAddArcToPoint(context, 0, 0, cornerRadius * 2, 0, cornerRadius); // 左上角
        CGContextAddArcToPoint(context, rectSize.width, 0, rectSize.width, cornerRadius * 2, cornerRadius); // 右上角
        
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
    if (array.count >= 2) {
        
        NSArray *rects = [self zn_eachRectInGroupWithCount2:array.count];
        int count = 0;
        for (id obj in array) {
            
            if (count > rects.count-1) {
                break;
            }
            
            UIImage *image;
            
            if ([obj isKindOfClass:[NSString class]]) {
                image = [UIImage imageNamed:(NSString *)obj];
            } else if ([obj isKindOfClass:[UIImage class]]){
                image = (UIImage *)obj;
            } else {
                NSLog(@"%s Unrecognizable class type", __FUNCTION__);
                break;
            }
            
            CGRect rect = CGRectFromString([rects objectAtIndex:count]);
            [image drawInRect:rect];
            count++;
        }
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void)zn_getRects:(NSMutableArray *)array
            padding:(CGFloat)padding
              width:(CGFloat)eachWidth
              count:(int)count {
    for (int i=0; i<count; i++) {
        int sqrtInt = (int)sqrt(count);
        int line = i%sqrtInt;
        int row = i/sqrtInt;
        CGRect rect = CGRectMake(padding * (line+1) + eachWidth * line, padding * (row+1) + eachWidth * row, eachWidth, eachWidth);
        [array addObject:NSStringFromCGRect(rect)];
    }
}

+ (NSArray *)zn_eachRectInGroupWithCount2:(NSInteger)count {
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];
    
    CGFloat sizeValue = 100;
    CGFloat padding = 2;
    
    CGFloat eachWidth;
    
    if (count <= 4) {
        eachWidth = (sizeValue - padding*3) / 2;
        [self zn_getRects:array padding:padding width:eachWidth count:4];
    } else {
        padding = padding / 2;
        eachWidth = (sizeValue - padding*4) / 3;
        [self zn_getRects:array padding:padding width:eachWidth count:9];
    }
    
    if (count < 4) {
        [array removeObjectAtIndex:0];
        CGRect rect = CGRectFromString([array objectAtIndex:0]);
        rect.origin.x = (sizeValue - eachWidth) / 2;
        [array replaceObjectAtIndex:0 withObject:NSStringFromCGRect(rect)];
        if (count == 2) {
            [array removeObjectAtIndex:0];
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:2];
            
            for (NSString *rectStr in array) {
                CGRect rect = CGRectFromString(rectStr);
                rect.origin.y -= (padding+eachWidth)/2;
                [tempArray addObject:NSStringFromCGRect(rect)];
            }
            [array removeAllObjects];
            [array addObjectsFromArray:tempArray];
        }
    } else if (count != 4 && count <= 6) {
        [array removeObjectsInRange:NSMakeRange(0, 3)];
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:6];
        
        for (NSString *rectStr in array) {
            CGRect rect = CGRectFromString(rectStr);
            rect.origin.y -= (padding+eachWidth)/2;
            [tempArray addObject:NSStringFromCGRect(rect)];
        }
        [array removeAllObjects];
        [array addObjectsFromArray:tempArray];
        
        if (count == 5) {
            [tempArray removeAllObjects];
            [array removeObjectAtIndex:0];
            
            for (int i=0; i<2; i++) {
                CGRect rect = CGRectFromString([array objectAtIndex:i]);
                rect.origin.x -= (padding+eachWidth)/2;
                [tempArray addObject:NSStringFromCGRect(rect)];
            }
            [array replaceObjectsInRange:NSMakeRange(0, 2) withObjectsFromArray:tempArray];
        }
        
    } else if (count != 4 && count < 9) {
        if (count == 8) {
            [array removeObjectAtIndex:0];
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:2];
            for (int i=0; i<2; i++) {
                CGRect rect = CGRectFromString([array objectAtIndex:i]);
                rect.origin.x -= (padding+eachWidth)/2;
                [tempArray addObject:NSStringFromCGRect(rect)];
            }
            [array replaceObjectsInRange:NSMakeRange(0, 2) withObjectsFromArray:tempArray];
        } else {
            [array removeObjectAtIndex:2];
            [array removeObjectAtIndex:0];
        }
    }
    
    return array;
}


@end
