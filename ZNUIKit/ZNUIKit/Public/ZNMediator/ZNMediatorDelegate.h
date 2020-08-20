//
//  ZNMediatorDelegate.h
//  ZNMediator
//
//  Created by 郑楠楠 on 2020/7/23.
//  Copyright © 2020 郑楠楠. All rights reserved.
//

#ifndef ZNMediatorDelegate_h
#define ZNMediatorDelegate_h

@protocol ZNMediatorDelegate <NSObject>

// 远程App调用入口
- (id _Nullable)performActionWithUrl:(NSURL * _Nullable)url
                          completion:(void(^_Nullable)(NSDictionary * _Nullable info))completion;

// 本地组件调用入口
- (id _Nullable)performTarget:(NSString * _Nullable)targetName
                        action:(NSString * _Nullable)actionName
                        params:(NSArray * _Nullable)params
             shouldCacheTarget:(BOOL)shouldCacheTarget;

/// 释放缓存的cachedTarget
/// @param fullTargetName <#fullTargetName description#>
- (void)releaseCachedTargetWithFullTargetName:(NSString * _Nullable) fullTargetName;

@end

#endif /* ZNMediatorDelegate_h */
