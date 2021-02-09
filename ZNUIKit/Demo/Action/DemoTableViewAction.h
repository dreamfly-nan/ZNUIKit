//
//  DemoTableViewAction.h
//  ZNUIKit
//
//  Created by 郑楠楠 on 2020/8/23.
//  Copyright © 2020 郑楠楠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZNTableViewKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface DemoTableViewAction : NSObject <ZNTableViewActionProtocol>

/// 便于操作刷新
@property(nonatomic , weak) id<ZNTableViewKitProtocol> tableViewKit;

@end

NS_ASSUME_NONNULL_END
