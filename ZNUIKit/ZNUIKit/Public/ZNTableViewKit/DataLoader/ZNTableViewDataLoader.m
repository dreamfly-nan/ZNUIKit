//
//  ZNTableViewDataLoader.m
//  ZNTableViewKit
//
//  Created by apple on 2020/7/24.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ZNTableViewDataLoader.h"
#import "ZNTableViewErrow.h"

typedef NS_ENUM(NSInteger,ZNTableViewDataType){
    ZNTableViewDataTypeSingleGroup = 0,                     ///单组数据源
    ZNTableViewDataTypeMoreGroup                            ///多组数据源
};

@interface ZNTableViewDataLoader()

@property(nonatomic , strong) NSArray * datasoure;

@property(nonatomic , assign) ZNTableViewDataType dataType;

@end

@implementation ZNTableViewDataLoader


- (instancetype)initSingleGroupWithDataSource:(NSArray *) dataSource{
    self.datasoure = dataSource;
    self.dataType = ZNTableViewDataTypeSingleGroup;
    return self;
}

- (instancetype)initMoreGroupWithDataSource:(NSArray *) dataSource{
    self.datasoure = dataSource;
    self.dataType = ZNTableViewDataTypeMoreGroup;
    return self;
}

#pragma mark - get

- (BOOL)haveData {
    if (self.datasoure.count > 0) {
        if (self.dataType == ZNTableViewDataTypeSingleGroup) {
            return  YES;
        }
        for (id model in self.datasoure) {
            if ([model isKindOfClass:[NSArray class]] || [model isKindOfClass:[NSMutableArray class]]) {
                NSArray * array = model;
                if (array.count > 0) {
                    return YES;
                }
            }
        }
        return NO;
    }
    return NO;
}

- (NSInteger)numberOfSection {
    if (self.dataType == ZNTableViewDataTypeSingleGroup) {
        return 1;
    }
    return self.datasoure.count;
}

- (NSInteger)numbserOfRowWithSecion:(NSInteger)section {
    ///单组类型
    if (self.dataType == ZNTableViewDataTypeSingleGroup) {
        return self.datasoure.count;
    }
    
    id model = self.datasoure[section];
    if ([model isKindOfClass:[NSArray class]] || [model isKindOfClass:[NSMutableArray class]]) {
        NSArray * array = model;
        return array.count;
    }
    return 0;
}

- (nonnull NSArray *)obtainArrayWithSecion:(NSInteger)section {
    if (self.dataType == ZNTableViewDataTypeSingleGroup) {
        if (section == 0) {
            return self.datasoure;
        }
    }
    
    id model = self.datasoure[section];
    if ([model isKindOfClass:[NSArray class]] || [model isKindOfClass:[NSMutableArray class]]) {
        return model;
    }
    return nil;
}

- (nonnull NSObject *)obtianObjectWithIndexPath:(nonnull NSIndexPath *) indexPath {
    if (self.dataType == ZNTableViewDataTypeSingleGroup) {
        if (self.datasoure.count > indexPath.row) {
            return self.datasoure[indexPath.row];
        }else{
            [ZNTableViewErrow throwWithAction:_cmd errowClass:self.class decriction:@"数组越界了" name:@"数组越界了"];
        }
    }else if(self.dataType == ZNTableViewDataTypeMoreGroup){
        if (self.datasoure.count > indexPath.section) {
            id model = self.datasoure[indexPath.section];
            if ([model isKindOfClass:[NSArray class]] || [model isKindOfClass:[NSMutableArray class]]) {
                NSArray * array = model;
                return array[indexPath.row];
            }else{
                [ZNTableViewErrow throwWithAction:_cmd errowClass:self.class decriction:@"数据模型不对" name:@"数据模型不对"];
            }
        }else{
            [ZNTableViewErrow throwWithAction:_cmd errowClass:self.class decriction:@"数组越界了" name:@"数组越界了"];
        }
    }
    return nil;
}

/// 重设数据源
/// @param array <#array description#>
- (void)setDataSourceWithArray:(id) array{
    self.datasoure = array;
}

/// 获取数据源
- (id) obtainDataSource{
    return self.datasoure;
}

/// 是否是下拉刷新数据
/// @param isReSetData <#isReSetData description#>
- (void)loadData:(BOOL) isReSetData{
    //默认为最后一页
    self.loadFinishBlock(nil, true);
}

/// 是否是头部
/// @param indexPath <#indexPath description#>
- (BOOL)isHeaderWithIndexPath:(NSIndexPath *) indexPath{
    if (self.dataType == ZNTableViewDataTypeSingleGroup) {
        if (indexPath.row == 0) {
            return YES;
        }
    }
    return NO;
}

/// 是否是尾部
/// @param indexPath <#indexPath description#>
- (BOOL)isFooterWithIndexPath:(NSIndexPath *) indexPath{
    if (self.dataType == ZNTableViewDataTypeSingleGroup) {
        if (indexPath.row == (self.datasoure.count - 1)) {
            return YES;
        }
    }else{
        NSObject * object = self.datasoure[indexPath.section];
        if ([object isKindOfClass:[NSArray class]]) {
            NSArray * array = object;
            if ((array.count - 1) == indexPath.row) {
                return YES;
            }
        }
    }
    return NO;
}
@end
