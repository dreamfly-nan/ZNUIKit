//
//  ZNTableViewHelper.h
//  ZNTableViewKit
//
//  Created by apple on 2020/7/24.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 加载过程
@protocol ZNTableViewLunchProtocol <NSObject>
@optional

/// 根据indexPath返回对应的cell的class
/// 默认取第一个注册的cell
/// @param indexPath <#indexPath description#>
/// @param model <#model description#>
- (Class)cellClassWithIndexPath:(NSIndexPath *) indexPath
                          model:(id) model;

/// 加载
/// @param cell <#cell description#>
/// @param indexPath <#indexPath description#>
- (void)lunchTableViewCell:(UITableViewCell *) cell
                 indexPath:(NSIndexPath *) indexPath;

/// cell即将出现时调用
/// @param cell <#cell description#>
/// @param indexPath <#indexPath description#>
- (void)willDisplayWithTableViewCell:(UITableViewCell *) cell
                           indexPath:(NSIndexPath *) indexPath;

@end

/// 布局
@protocol ZNTableViewLayoutProtocol <NSObject>

@optional
/// 每一项的高度，优先使用这边回掉的高度值，没有实现则直接取注册的高度值，
/// 没设置注册的高度值，则直接使用默认高度值
/// @param indexPath <#indexPath description#>
/// @param model <#model description#>
- (CGFloat)rowHeightWithIndexPath:(NSIndexPath *) indexPath
                        tableView:(UITableView *) tableView
                            model:(id) model;
/// 组头的高度
/// @param section <#section description#>
- (CGFloat)headHeightWithSection:(NSInteger) section;

/// 组头
/// @param section <#section description#>
- (UIView *)headViewWithSection:(NSInteger) section;

/// 组尾的高度
/// @param section <#section description#>
- (CGFloat)footerHeightWithSection:(NSInteger) section;

/// 组尾
/// @param section <#section description#>
- (UIView *)footerViewWithSection:(NSInteger) section;

@end

@interface ZNTableViewHelper : NSObject
<ZNTableViewLayoutProtocol,
ZNTableViewLunchProtocol>

@end

NS_ASSUME_NONNULL_END
