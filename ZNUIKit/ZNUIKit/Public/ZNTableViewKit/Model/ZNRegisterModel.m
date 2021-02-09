//
//  ZNRegisterModel.m
//  ZNTableViewKit
//
//  Created by apple on 2020/7/24.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ZNRegisterModel.h"

@interface ZNRegisterModel()

@property(nonatomic , strong) Class cellClass;

///模型名称
@property(nonatomic , strong) NSString * modelName;

@property(nonatomic , assign) BOOL cutsHeight;

@end

@implementation ZNRegisterModel


/// 注册cell
/// @param cellClass <#cellClass description#>
+ (instancetype)initWithCellClass:(Class) cellClass{
    ZNRegisterModel * model = [ZNRegisterModel new];
    model.cellClass = cellClass;
    return model;
}

/// 注册cell，并且注册cell对应的model对象
/// @param cellClass <#cellClass description#>
/// @param modelName <#modelName description#>
+ (instancetype)initWithCellClass:(Class)cellClass
                        modelName:(NSString*) modelName{
    ZNRegisterModel * model = [ZNRegisterModel new];
    model.cellClass = cellClass;
    model.modelName = modelName;
    return model;
}

+ (NSArray *)initWithArrayCellClass:(NSArray<Class> *) arrayClass{
    if (arrayClass.count <= 0) {
        return nil;
    }
    NSMutableArray * arrayModel = [NSMutableArray new];
    for (Class cellClass in arrayClass) {
        [arrayModel addObject:[ZNRegisterModel initWithCellClass:cellClass]];
    }
    return arrayModel;
}

#pragma mark - set

- (void)setHeight:(CGFloat)height{
    _height = height;
    self.cutsHeight = YES;
}

@end
