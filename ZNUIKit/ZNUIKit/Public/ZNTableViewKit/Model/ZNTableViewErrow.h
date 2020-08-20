//
//  ZNTableViewErrow.h
//  ZNTableViewKit
//
//  Created by apple on 2020/7/24.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZNTableViewErrow : NSObject

+ (void)throwWithAction:(SEL) action
             errowClass:(Class) errowClass
             decriction:(NSString *)decriction
                   name:(NSString *) name;

@end

NS_ASSUME_NONNULL_END
