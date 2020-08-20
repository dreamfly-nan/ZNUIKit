//
//  ZNTableViewManage.m
//  ZNTableViewKit
//
//  Created by apple on 2020/7/27.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ZNTableViewManage.h"
#import "ZNTableViewCellProtocol.h"

@implementation ZNTableViewManage

#pragma mark -ZNTableViewManageProtocol

/// 根据indexPath返回UITableViewCell
/// 
/// @param indexPath <#indexPath description#>
- (Class)managerCellClassWithIndexPath:(NSIndexPath *) indexPath{
    if (self.dataLoader && [self.dataLoader respondsToSelector:@selector(obtianObjectWithIndexPath:)]) {
        if (self.viewHelper && [self.viewHelper respondsToSelector:@selector(cellClassWithIndexPath:model:)]) {
            return [self.viewHelper cellClassWithIndexPath:indexPath model:[self.dataLoader obtianObjectWithIndexPath:indexPath]];
        }
    }
    
    ///获取第一个注册的cell，排除组件自己注册的cell
    if (self.registerCellModels.count) {
        for (ZNRegisterModel * model in self.registerCellModels.allValues) {
            if (![model.class isKindOfClass:[UITableViewCell class]]) {
                return model.cellClass;
            }
        }
    }
    return [UITableViewCell class];
}

/// 加载
/// @param cell <#cell description#>
/// @param indexPath <#indexPath description#>
- (void)managerLunchTableViewCell:(UITableViewCell *) cell
                        indexPath:(NSIndexPath *) indexPath{
    UITableViewCell<ZNBaseTableViewCellProtocol> * cellProtocol = (UITableViewCell<ZNBaseTableViewCellProtocol> *) cell;
    if (cellProtocol && [cellProtocol respondsToSelector:@selector(loadModel:withIndexPath:)]) {
        if (self.dataLoader && [self.dataLoader respondsToSelector:@selector(obtianObjectWithIndexPath:)]) {
            [cellProtocol loadModel:[self.dataLoader obtianObjectWithIndexPath:indexPath] withIndexPath:indexPath];
        }
    }
    
    if (cellProtocol && [cellProtocol respondsToSelector:@selector(setSubViewAction:)]) {
        [cellProtocol setSubViewAction:self.cellAction];
    }
    
    if (self.viewHelper && [self.viewHelper respondsToSelector:@selector(lunchTableViewCell:indexPath:)]) {
        [self.viewHelper lunchTableViewCell:cell indexPath:indexPath];
    }
}

/// 设置每个cell的高度
/// @param indexPath <#indexPath description#>
- (CGFloat)managerRowHeightWithIndexPath:(NSIndexPath *) indexPath{
    if (self.viewHelper && [self.viewHelper respondsToSelector:@selector(rowHeightWithIndexPath:tableView:model:)]) {
        id model = nil;
        if (self.dataLoader && [self.dataLoader respondsToSelector:@selector(obtianObjectWithIndexPath:)]) {
            model = [self.dataLoader obtianObjectWithIndexPath:indexPath];
        }
        return [self.viewHelper rowHeightWithIndexPath:indexPath tableView:self.tableView model:model];
    }
    
    if ([self respondsToSelector:@selector(managerCellClassWithIndexPath:)]) {
        Class cellClass = [self managerCellClassWithIndexPath:indexPath];
        ZNRegisterModel * model = self.registerCellModels[NSStringFromClass(cellClass)];
        if (model) {
            return model.height;
        }
    }
    return 0;
}

/// cell将要出现的时候
/// @param cell <#cell description#>
/// @param indexPath <#indexPath description#>
- (void)managerWillDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.viewHelper && [self.viewHelper respondsToSelector:@selector(willDisplayWithTableViewCell:indexPath:)]) {
        [self.viewHelper willDisplayWithTableViewCell:cell indexPath:indexPath];
    }
    
    UITableViewCell<ZNBaseTableViewCellProtocol> * baseCell = (UITableViewCell<ZNBaseTableViewCellProtocol> *)cell;
    if (baseCell && [baseCell respondsToSelector:@selector(loadModel:withIndexPath:)]) {
        id model = nil;
        if (self.dataLoader && [self.dataLoader respondsToSelector:@selector(obtianObjectWithIndexPath:)]) {
            model = [self.dataLoader obtianObjectWithIndexPath:indexPath];
        }
        [baseCell loadModel:model withIndexPath:indexPath];
    }
}

/// 组数
/// @param tableView <#tableView description#>
- (NSInteger)managerNumberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataLoader && [self.dataLoader respondsToSelector:@selector(haveData)]) {
        if ([self.dataLoader haveData]) {
            if ([self.dataLoader respondsToSelector:@selector(numberOfSection)]) {
                return [self.dataLoader numberOfSection];
            }
        }
    }
    return 0;
}

/// 每一组多少个
/// @param section <#section description#>
- (NSInteger)managerNumberOfRowsInSection:(NSInteger)section{
    if (self.dataLoader && [self.dataLoader respondsToSelector:@selector(numbserOfRowWithSecion:)]) {
        return [self.dataLoader numbserOfRowWithSecion:section];
    }
    return 0;
}

/// <#Description#>
/// @param section <#section description#>
- (UIView *)managerViewHeaderInSection:(NSInteger)section{
    if (self.viewHelper && [self.viewHelper respondsToSelector:@selector(headerViewForSection:)]) {
        return [self.viewHelper headViewWithSection:section];
    }
    return [UIView new];
}

/// <#Description#>
/// @param section <#section description#>
- (CGFloat)managerHeightForHeaderInSection:(NSInteger)section{
    if (self.viewHelper && [self.viewHelper respondsToSelector:@selector(headHeightWithSection:)]) {
        return [self.viewHelper headHeightWithSection:section];
    }
    return 0.01f;
}

/// <#Description#>
/// @param section <#section description#>
- (UIView *)managerViewForFooterInSection:(NSInteger)section{
    if (self.viewHelper && [self.viewHelper respondsToSelector:@selector(footerViewWithSection:)]) {
        return [self.viewHelper footerViewWithSection:section];
    }
    return [UIView new];
}

/// <#Description#>
/// @param section <#section description#>
- (CGFloat)managerHeightForFooterInSection:(NSInteger)section{
    if (self.viewHelper && [self.viewHelper respondsToSelector:@selector(footerHeightWithSection:)]) {
        return [self.viewHelper footerHeightWithSection:section];
    }
    return 0.01f;
}

#pragma mark - strategy 策略相关

/// 刷新数据源的时候调用
/// @param strategy <#strategy description#>
- (void)reloadWithStrategy:(id<ZNTableViewStrategyProtocol>) strategy{
    if (strategy == nil) {
        return;
    }
    
    if (self.dataLoader && [self.dataLoader respondsToSelector:@selector(setDataSourceWithArray:)]) {
         NSArray * array = [self.dataLoader obtainDataSource];
        ///筛选数据
        if ([strategy respondsToSelector:@selector(strategyFilterWtihArray:)]) {
            array = [strategy strategyFilterWtihArray:array];
        }
        ///刷新数据源
        if ([strategy respondsToSelector:@selector(strategyUpdateWithArray:)]) {
            [strategy strategyUpdateWithArray:array];
        }
        [self.dataLoader setDataSourceWithArray:array];
    }
}

@end
