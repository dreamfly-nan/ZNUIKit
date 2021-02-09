//
//  ZNTableViewKitProtocol.h
//  ZNTableViewKit
//
//  Created by zhengnannan on 2020/8/20.
//  Copyright © 2020 apple. All rights reserved.
//

#ifndef ZNTableViewKitProtocol_h
#define ZNTableViewKitProtocol_h
#import <UIKit/UIKit.h>
#import "ZNTableViewDataLoader.h"

@protocol ZNTableViewKitProtocol <NSObject>

/// 刷新tableView
- (void)reload;

/// 获取数据源
- (id<ZNTableViewDataSourceProtocol>)getDataLoader;

/// 获取当前的Tableview
- (UITableView *)getCurrentTableView;

@end

#endif /* ZNTableViewKitProtocol_h */
