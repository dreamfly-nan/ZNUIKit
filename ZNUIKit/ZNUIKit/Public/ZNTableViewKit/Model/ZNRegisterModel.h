//
//  ZNRegisterModel.h
//  ZNTableViewKit
//
//  Created by apple on 2020/7/24.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZNRegisterModel : NSObject
@property(nonatomic , strong, readonly) Class cellClass;

///模型名称
@property(nonatomic , strong, readonly) NSString * modelName;

@property(nonatomic , assign) CGFloat height;

@property(nonatomic , assign ,readonly) BOOL cutsHeight;

/// 注册cell
/// @param cellClass <#cellClass description#>
+ (instancetype)initWithCellClass:(Class) cellClass;

/// 注册cell，并且注册cell对应的model对象
/// @param cellClass <#cellClass description#>
/// @param modelName <#modelName description#>
+ (instancetype)initWithCellClass:(Class)cellClass
                        modelName:(NSString*) modelName;

+ (NSArray *)initWithArrayCellClass:(NSArray<Class> *) arrayClass;

@end

NS_ASSUME_NONNULL_END
