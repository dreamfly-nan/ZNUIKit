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

@property(nonatomic , assign) CGFloat height;

@property(nonatomic , assign ,readonly) BOOL cutsHeight;

+ (instancetype)initWithCellClass:(Class) cellClass;

+ (NSArray *)initWithArrayCellClass:(NSArray<Class> *) arrayClass;

@end

NS_ASSUME_NONNULL_END
