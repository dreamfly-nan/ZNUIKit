//
//  ZNTableViewManage.h
//  ZNTableViewKit
//  尽量使用继承方式
//  Created by apple on 2020/7/27.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZNTableViewDataLoader.h"
#import "ZNTableViewHelper.h"
#import "ZNTableViewActionProtocol.h"
#import "ZNTableViewStrategyProtocol.h"
#import "ZNRegisterModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZNTableViewManageProtocol <NSObject>
@optional
/// 根据indexPath返回UITableViewCell
///
/// @param indexPath <#indexPath description#>
- (Class)managerCellClassWithIndexPath:(NSIndexPath *) indexPath;

/// 加载
/// @param cell <#cell description#>
/// @param indexPath <#indexPath description#>
- (void)managerLunchTableViewCell:(UITableViewCell *) cell
                        indexPath:(NSIndexPath *) indexPath;

/// 设置每个cell的高度
/// @param indexPath <#indexPath description#>
- (CGFloat)managerRowHeightWithIndexPath:(NSIndexPath *) indexPath;

/// cell将要出现的时候
/// @param cell <#cell description#>
/// @param indexPath <#indexPath description#>
- (void)managerWillDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

/// 组数
/// @param tableView <#tableView description#>
- (NSInteger)managerNumberOfSectionsInTableView:(UITableView *)tableView;

/// 每一组多少个
/// @param section <#section description#>
- (NSInteger)managerNumberOfRowsInSection:(NSInteger)section;

/// 组头
/// @param section <#section description#>
- (UIView *)managerViewHeaderInSection:(NSInteger)section;

/// 组头高度
/// @param section <#section description#>
- (CGFloat)managerHeightForHeaderInSection:(NSInteger)section;

/// 组尾
/// @param section <#section description#>
- (UIView *)managerViewForFooterInSection:(NSInteger)section;

/// 组尾高度
/// @param section <#section description#>
- (CGFloat)managerHeightForFooterInSection:(NSInteger)section;


#pragma mark - strategy 策略相关

/// 刷新数据源的时候调用
/// @param strategy <#strategy description#>
- (void)reloadWithStrategy:(id<ZNTableViewStrategyProtocol>) strategy;

@end

@interface ZNTableViewManage : NSObject <ZNTableViewManageProtocol>

@property(nonatomic , strong) UITableView * tableView;

@property(nonatomic , weak) id<ZNTableViewLayoutProtocol,ZNTableViewLunchProtocol> viewHelper;

@property(nonatomic , weak) id<ZNTableViewDataSourceDelegate> dataLoader;

@property(nonatomic , weak) id<ZNTableViewActionProtocol> cellAction;

/// cell的注册数据模型
@property(nonatomic , strong) NSMutableDictionary<NSString *, ZNRegisterModel *> * registerCellModels;

@end

NS_ASSUME_NONNULL_END
