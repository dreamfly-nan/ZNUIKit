//
//  DemoTableViewAction.m
//  ZNUIKit
//
//  Created by 郑楠楠 on 2020/8/23.
//  Copyright © 2020 郑楠楠. All rights reserved.
//

#import "DemoTableViewAction.h"
#import "ZNTableViewActionProtocol.h"

@implementation DemoTableViewAction

/// cell的点击事件
/// @param cell <#cell description#>
/// @param model <#model description#>
/// @param indexPath <#indexPath description#>
- (void)didSelectItemWithCell:(UITableViewCell *) cell
                        model:(id) model
                    indexPath:(NSIndexPath *) indexPath{
    
}

/// cell的子控件的事件触发
/// @param code 事件编号
/// @param model cell的数据模型
/// @param cell cell本身视图
- (void)cellSubViewActionWithCode:(NSString *) code
                             cell:(UITableViewCell *) cell
                            model:(id) model{
    
}

@end
