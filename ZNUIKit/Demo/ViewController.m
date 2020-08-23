//
//  ViewController.m
//  ZNUIKit
//
//  Created by 郑楠楠 on 2020/7/22.
//  Copyright © 2020 郑楠楠. All rights reserved.
//

#import "ViewController.h"
#import "ZNUIKit.h"
#import "ZNTableViewKit.h"
#import "DemoTableViewCell.h"
@interface ViewController ()

@property (nonatomic , strong) UITableView * tableView;

@property (nonatomic , strong) ZNTableViewKit * tableviewKit;

@property (nonatomic , strong) NSArray * dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - get

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    return _tableView;
}

- (ZNTableViewKit *)tableviewKit{
    if (!_tableviewKit) {
        _tableviewKit = [[ZNTableViewKit alloc] initWithSingleGroupTableView:self.tableView dataSource:self.dataSource];
    }
    return _tableviewKit;
}

- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"ZNTableViewKit的使用"];
    }
    return _dataSource;
}

@end
