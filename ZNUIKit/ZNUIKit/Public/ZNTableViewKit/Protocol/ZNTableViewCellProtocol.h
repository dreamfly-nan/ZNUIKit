//
//  ZNTableViewCellProtocol.h
//  ZNTableViewKit
//
//  Created by zhengnannan on 2020/8/18.
//  Copyright © 2020 apple. All rights reserved.
//

#ifndef ZNTableViewCellProtocol_h
#define ZNTableViewCellProtocol_h

#import <UIKit/UIKit.h>
#import "ZNTableViewActionProtocol.h"

@protocol ZNBaseTableViewCellProtocol <NSObject>

- (void)loadModel:(id) model
    withIndexPath:(NSIndexPath *) indexPath;

- (void)setSubViewAction:(id<ZNTableViewActionProtocol>) action;

@end

#endif /* ZNTableViewCellProtocol_h */
