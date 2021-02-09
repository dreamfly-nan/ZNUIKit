//
//  ZNTableViewDataLoader.h
//  ZNTableViewKit
//
//  Created by apple on 2020/7/24.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void (^ZNLoadFinishBlock)(NSError * _Nullable error,BOOL isLastPage);

@protocol ZNTableViewDataSourceProtocol <NSObject>
/// 加载完成后回调
@property(nonatomic, copy,nullable) ZNLoadFinishBlock loadFinishBlock;

/// 重设数据源
/// @param array <#array description#>
- (void)setDataSourceWithArray:(id) array;

/// 获取数据源
- (id)obtainDataSource;

/// 是否有数据,未实现则默认无数据
- (BOOL)haveData;

/// 是否是下拉刷新数据
/// @param isReSetData <#isReSetData description#>
- (void)loadData:(BOOL)isReSetData;

/// 组数 - 未实现则默认返回0
- (NSInteger)numberOfSection;

/// 每组的row数量
/// @param section <#section description#>
- (NSInteger)numbserOfRowWithSecion:(NSInteger)section;

/// 根据indexPath获取对应的数据模型
/// @param indexPath <#indexPath description#>
- (NSObject *)obtianObjectWithIndexPath:(NSIndexPath *)indexPath;

/// 获取该组的数据数组
/// @param section <#section description#>
- (NSArray *)obtainArrayWithSecion:(NSInteger)section;

@optional

/// 是否是头部
/// @param indexPath <#indexPath description#>
- (BOOL)isHeaderWithIndexPath:(NSIndexPath *) indexPath;

/// 是否是尾部
/// @param indexPath <#indexPath description#>
- (BOOL)isFooterWithIndexPath:(NSIndexPath *) indexPath;

@end

@interface ZNTableViewDataLoader : NSObject <ZNTableViewDataSourceProtocol>

/// 加载完成后回调
@property(nonatomic , copy,nullable) ZNLoadFinishBlock loadFinishBlock;

- (instancetype)initSingleGroupWithDataSource:(NSArray *) dataSource;

- (instancetype)initMoreGroupWithDataSource:(NSArray *) dataSource;

@end

NS_ASSUME_NONNULL_END
