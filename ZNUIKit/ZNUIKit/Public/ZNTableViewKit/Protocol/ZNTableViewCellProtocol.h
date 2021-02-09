//
//  ZNTableViewCellProtocol.h
//  ZNTableViewKit
//
//  Created by zhengnannan on 2020/8/18.
//  Copyright © 2020 apple. All rights reserved.
//

#ifndef ZNTableViewCellProtocol_h
#define ZNTableViewCellProtocol_h

#import <UIKit/UIKit.h>
#import "ZNTableViewActionProtocol.h"

@protocol ZNBaseViewProtocol <NSObject>

@optional

/// 设置事件对象
/// @param action <#action description#>
- (void)setSubViewAction:(id<ZNTableViewActionProtocol>) action;


@end

@protocol ZNBaseTableViewCellProtocol <ZNBaseViewProtocol>

- (void)loadModel:(id) model
    withIndexPath:(NSIndexPath *) indexPath;

@optional
/// 是否是头部和尾部
/// @param isHead <#isHead description#>
/// @param isFooter <#isFooter description#>
- (void)isHeaderOrFooter:(BOOL) isHead
                isFooter:(BOOL) isFooter;

@end

#endif /* ZNTableViewCellProtocol_h */
