//
//  DemoTableViewCell.m
//  ZNUIKit
//
//  Created by 郑楠楠 on 2020/8/23.
//  Copyright © 2020 郑楠楠. All rights reserved.
//

#import "DemoTableViewCell.h"

@implementation DemoTableViewCell

- (void)loadModel:(id) model
    withIndexPath:(NSIndexPath *) indexPath{
    if ([model isKindOfClass:[NSString class]]) {
        self.textLabel.text = model;
        self.textLabel.textColor = [UIColor blackColor];
    }
}

- (void)setSubViewAction:(id<ZNTableViewActionProtocol>) action{
    
}

@end
