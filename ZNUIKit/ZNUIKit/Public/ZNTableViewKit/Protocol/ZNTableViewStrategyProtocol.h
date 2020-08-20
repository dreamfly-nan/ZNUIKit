//
//  ZNTableViewStrategyProtocol.h
//  ZNTableViewKit
//
//  Created by zhengnannan on 2020/8/20.
//  Copyright © 2020 apple. All rights reserved.
//

#ifndef ZNTableViewStrategyProtocol_h
#define ZNTableViewStrategyProtocol_h
#import <UIKit/UIKit.h>

@protocol ZNTableViewStrategyProtocol <NSObject>

@optional

/// 数据过滤
/// @param array <#array description#>
- (NSArray *)strategyFilterWtihArray:(NSArray *) array;

/// 供策略本身调用，其他地方不会调用
/// @param model <#model description#>
- (BOOL)strategyFillerWithModel:(id) model;

/// 数据处理，更新
/// @param array <#array description#>
- (NSArray *)strategyUpdateWithArray:(NSArray *) array;

@end

#endif /* ZNTableViewStrategyProtocol_h */
