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
        NSObject * cellModel = [self.dataLoader obtianObjectWithIndexPath:indexPath];
        for (ZNRegisterModel * model in self.registerCellModels.allValues) {
            ///如果使用者自定义了对应类型，则使用自定义的类型
            if (model.modelName) {
                if ([model.modelName isEqualToString:NSStringFromClass(cellModel.class)]) {
                    return model.cellClass;
                }
            }else{
                if (![model.class isKindOfClass:[UITableViewCell class]]) {
                    return model.cellClass;
                }
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
    UITableViewCell<ZNBaseTableViewCellProtocol> * baseCell = (UITableViewCell<ZNBaseTableViewCellProtocol> *)cell;
    if (baseCell && [baseCell respondsToSelector:@selector(loadModel:withIndexPath:)]) {
        id model = nil;
        if (self.dataLoader && [self.dataLoader respondsToSelector:@selector(obtianObjectWithIndexPath:)]) {
            model = [self.dataLoader obtianObjectWithIndexPath:indexPath];
        }
        [baseCell loadModel:model withIndexPath:indexPath];
    }
    
    if (baseCell && [baseCell respondsToSelector:@selector(isHeaderOrFooter:isFooter:)]) {
        BOOL isHeader = NO;
        BOOL isFooter = NO;
        if ([self.dataLoader respondsToSelector:@selector(isHeaderWithIndexPath:)]) {
            isHeader = [self.dataLoader isHeaderWithIndexPath:indexPath];
        }
        if ([self.dataLoader respondsToSelector:@selector(isFooterWithIndexPath:)]) {
            isFooter = [self.dataLoader isFooterWithIndexPath:indexPath];
        }
        [baseCell isHeaderOrFooter:isHeader isFooter:isFooter];
    }
    
    if (self.viewHelper && [self.viewHelper respondsToSelector:@selector(willDisplayWithTableViewCell:indexPath:)]) {
        [self.viewHelper willDisplayWithTableViewCell:cell indexPath:indexPath];
    }
}

/// 组数
/// @param tableView <#tableView description#>
- (NSInteger)managerNumberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataLoader && [self.dataLoader respondsToSelector:@selector(haveData)]) {
        if ([self.dataLoader haveData]) {
            self.emptyView.hidden = YES;
            self.footerRefresh.hidden = NO;
            if ([self.dataLoader respondsToSelector:@selector(numberOfSection)]) {
                return [self.dataLoader numberOfSection];
            }
        }else{
            self.emptyView.hidden = NO;
            self.footerRefresh.hidden = YES;
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
    if (self.viewHelper && [self.viewHelper respondsToSelector:@selector(headViewWithSection:)]) {
        UIView<ZNBaseViewProtocol> * headView = [self.viewHelper headViewWithSection:section];
        if (headView && [headView respondsToSelector:@selector(setSubViewAction:)]) {
            [headView setSubViewAction:self.cellAction];
        }
        if (headView) {
            return headView;
        }
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
        UIView<ZNBaseViewProtocol> * footerView = [self.viewHelper footerViewWithSection:section];
        if (footerView && [footerView respondsToSelector:@selector(setSubViewAction:)]) {
            [footerView setSubViewAction:self.cellAction];
        }
        if (footerView) {
            return footerView;
        }
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
         id array = [self.dataLoader obtainDataSource];
        ///筛选数据
        if ([strategy respondsToSelector:@selector(strategyFilterWtihArray:)]) {
            array = [strategy strategyFilterWtihArray:array];
        }
        ///刷新数据源
        if ([strategy respondsToSelector:@selector(strategyUpdateWithArray:)]) {
            array = [strategy strategyUpdateWithArray:array];
        }
        [self.dataLoader setDataSourceWithArray:array];
    }
}


@end
