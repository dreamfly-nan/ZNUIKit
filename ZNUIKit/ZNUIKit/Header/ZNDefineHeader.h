//
//  ZNDefineHeader.h
//  JokeContent
//
//  Created by 南木南木 on 2019/7/26.
//  Copyright © 2019 南木南木. All rights reserved.
//

#ifndef ZNDefineHeader_h
#define ZNDefineHeader_h

//弱引用
#define znWeakSelf(x) __weak typeof(x) weakObject = (x);
#define znStrongSelf __strong typeof(weakObject) weakSelf = weakObject;

//代码块
#define znBlockSelf(x) __block typeof(x) blockSelf = (x);

/*TabBar高度*/
#define znTabBarHeight (CGFloat)(kIs_iPhoneX?(49.0 + 34.0):(49.0))

//状态栏高度大小
#define znStateSize [UIApplication sharedApplication].statusBarFrame.size
#define znStateHeight zn_stateHeight()

#define NAV_Height ([[UIApplication sharedApplication] statusBarFrame].size.height + 44)

//屏幕像素比例
#define znScreenScale ([[UIScreen mainScreen] scale])

#define znString(x) [NSString stringWithFormat:@"%@",x]

#define znIntToStr(x) [NSString stringWithFormat:@"%d",x]

#define znLongToStr(x) [NSString stringWithFormat:@"%ld",x]

#define znFloatToStr(x) [NSString stringWithFormat:@"%0.2f",x]

#define UIImageMake(img) [UIImage imageNamed:img]

/// UIColor 相关的宏，用于快速创建一个 UIColor 对象，更多创建的宏可查看
#define UIColorMake(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIColorMakeWithRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]

#pragma mark - ===================字符串取===========================
#define StringValue(object) [NSString stringWithFormat:@"%@",object]
#define StringFormat(format,...) [NSString stringWithFormat:format, ##__VA_ARGS__]

#define TransformString(stringChange) [NSString stringWithFormat:@"%@", stringChange]
#define TransformFloat(floatChange) [NSString stringWithFormat:@"%f", floatChange]
#define TransformNSInteger(integerChange) [NSString stringWithFormat:@"%d", integerChange]

#pragma mark -==================时间性能分析==========================

#define TICK CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();

#define TOCK NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start);

#endif /* ZNDefineHeader_h */
