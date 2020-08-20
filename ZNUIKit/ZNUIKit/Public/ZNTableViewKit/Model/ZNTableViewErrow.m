//
//  ZNTableViewErrow.m
//  ZNTableViewKit
//
//  Created by apple on 2020/7/24.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ZNTableViewErrow.h"

@implementation ZNTableViewErrow

+ (void)throwWithAction:(SEL) action
             errowClass:(Class) errowClass
             decriction:(NSString *)decriction
                   name:(NSString *) name{
    //抛异常
    NSString*info = [NSString stringWithFormat:@"-[%@ %@]:%@",errowClass,NSStringFromSelector(action),decriction];
    @throw [[NSException alloc] initWithName:name reason:info userInfo:nil];
}

@end
