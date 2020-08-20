//
//  UIImage+ZNCreate.h
//  JokeContent
//
//  Created by 南木南木 on 2019/7/4.
//  Copyright © 2019 南木南木. All rights reserved.
//



#import "ThreeHeadFile.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZNCreate)

/**
 获取文件中的图片，返回UIImage对象

 @param name 文件名
 @param type 文件类型
 @return <#return value description#>
 */
+ (UIImage*)zn_createWithFileName:(NSString*) name
                             type:(NSString*) type;

/**
 根据本地url获取图片

 @param url <#url description#>
 @param block <#block description#>
 */
+ (void)zn_createWithLocationUrl:(NSString*) url
                           block:(void (^)(UIImage * image)) block;

/**
  使用这个方法获取到的截图，图片文字都会变模糊

 @param view 需要截图的view
 @return <#return value description#>
 */
+ (UIImage *)zn_createImageVagueWithView:(UIView *) view;

/**
  使用该方法生成的图片不会模糊，根据屏幕密度计算

  @param view 需要截图的view
  @return <#return value description#>
 */
+ (UIImage *)zn_createImageWithView:(UIView *) view;

/**
 根据CIImage对象生成UIImage对象
 
 @param image ciimage对象
 @param size 生成的图片大小
 @return 生成的图片
 */
+ (UIImage *)zn_createImageWithCIImage:(CIImage *)image withSize:(CGSize)size;

/**
 根据指定的颜色生成一张指定大小的纯色图片
 
 @param color 颜色
 @param size 大小
 @return 一张图片
 */
+ (UIImage *)zn_createImageWithColor:(UIColor *)color size:(CGSize)size;

/** 根据颜色生成纯色图片 */
+ (UIImage *)zn_createImageWithColor:(UIColor *)color;

/**
 生成类似微信群一样的群头像图片
 图片组 本地
 @param array 原生image arr
 @param bgColor 新生成image 背景色
 @return image 组合
 */
+ (UIImage *)zn_crateGroupIconWith:(NSArray *)array
                           bgColor:(UIColor *)bgColor;

/**
 生成类似微信群一样的群头像图片
 图片组 本地
 @param corner 新生成组合图片背景圆角
 @param array 原生image arr
 @param bgColor 新生成image 背景色
 @return image 组合
 */
+ (UIImage *)zn_createGroupIconWith:(NSArray *)array
                             corner:(CGFloat)corner
                            bgColor:(UIColor *)bgColor;

/**
  生成类似微信群一样的群头像图片
 图片组合 网络请求，使用SD缓存到本地磁盘，请求前先去缓存中哈希查找是否有缓存
 @param URLArray 图片url 数组
 @param corner 新生成组合图片背景圆角
 @param bgColor 新生成组合图片背景颜色
 @param Success 组合成功回调
 @param Failed 组合失败回调
 */
+ (void )zn_createGroupIconWithURLArray:(NSArray *)URLArray
                                 corner:(CGFloat)corner
                                bgColor:(UIColor *)bgColor
                                Success:(void(^)(UIImage *image))Success
                                 Failed:(void(^)(NSString *fail))Failed;
/**
  生成类似微信群一样的群头像图片
 图片组合 网络请求，使用SD缓存到本地磁盘，请求前先去缓存中哈希查找是否有缓存
 @param URLArray 图片url 数组
 @param bgColor 新生成组合图片背景颜色
 @param Success 组合成功回调
 @param Failed 组合失败回调
 */
+ (void)zn_createGroupIconWithURLArray:(NSArray *)URLArray
                               bgColor:(UIColor *)bgColor
                               Success:(void(^)(UIImage *image))Success
                                Failed:(void(^)(NSString *fail))Failed;

@end

NS_ASSUME_NONNULL_END
