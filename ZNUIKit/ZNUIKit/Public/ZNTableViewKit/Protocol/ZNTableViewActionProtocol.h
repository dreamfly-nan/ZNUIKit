//
//  ZNTableViewActionProtocol.h
//  ZNTableViewKit
//
//  Created by zhengnannan on 2020/8/18.
//  Copyright © 2020 apple. All rights reserved.
//

#ifndef ZNTableViewActionProtocol_h
#define ZNTableViewActionProtocol_h
#import <UIKit/UIKit.h>
#import "ZNTableViewKitProtocol.h"

@protocol ZNTableViewActionProtocol <NSObject>

/// 便于操作刷新
@property(nonatomic , weak) id<ZNTableViewKitProtocol> tableViewKit;

@optional
/// cell的点击事件
/// @param cell <#cell description#>
/// @param model <#model description#>
/// @param indexPath <#indexPath description#>
- (void)didSelectItemWithCell:(UITableViewCell *) cell
                        model:(id) model
                    indexPath:(NSIndexPath *) indexPath;

/// cell的子控件的事件触发
/// @param code 事件编号
/// @param model cell的数据模型
/// @param cell cell本身视图
- (void)cellSubViewActionWithCode:(NSString *) code
                             cell:(UITableViewCell *) cell
                            model:(id) model;

/// 组头视图的点击事件
/// @param code <#code description#>
/// @param headerView <#headView description#>
/// @param model <#model description#>
- (void)headerViewActionWithCode:(NSString *) code
                      headerView:(UIView*) headerView
                           model:(id) model;

/// 组尾视图的点击事件
/// @param code <#code description#>
/// @param footerView <#headView description#>
/// @param model <#model description#>
- (void)footerViewActionWithCode:(NSString *) code
                      footerView:(UIView*) footerView
                           model:(id) model;


@end

#endif /* ZNTableViewActionProtocol_h */
