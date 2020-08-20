//
//  ZNTableViewKit.m
//  ZNTableViewKit
//
//  Created by apple on 2020/7/24.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ZNTableViewKit.h"
#import "ZNTableViewErrow.h"

///设置默认高度
#define ZNHeadHeigth 0.01
#define ZNFooterHeight 0.01
#define ZNdefaultHeight 0.01
#define ZNCellHeight 50

@interface ZNTableViewKit()
<UITableViewDelegate,
UITableViewDataSource>

@property(nonatomic , strong) UITableView * tableView;

@property(nonatomic , strong) ZNTableViewManage * selfManager;

@property(nonatomic , strong) id<ZNTableViewLayoutProtocol,ZNTableViewLunchProtocol> viewHelper;

@property(nonatomic , strong) id<ZNTableViewDataSourceDelegate> dataLoader;

/// 事件管理
@property(nonatomic , strong) id<ZNTableViewActionProtocol> actionDelegate;

/// cell的注册数据模型
@property(nonatomic , strong) NSMutableDictionary<NSString *, ZNRegisterModel *> *registerCellModels;

///策略
@property(nonatomic , strong) NSMutableDictionary<NSString *, id<ZNTableViewStrategyProtocol> > * registerStrategyModels;

@end

@implementation ZNTableViewKit

#pragma mark - public

/// <#Description#>
/// @param tableView <#tableView description#>
- (instancetype)initWithSingleGroupTableView:(UITableView *) tableView
                                  dataSource:(NSArray *) dataSource{
    return [self initWithViewHelper:[ZNTableViewHelper new] dataLoader:[[ZNTableViewDataLoader alloc] initSingleGroupWithDataSource:dataSource] tableView:tableView];
}

/// <#Description#>
/// @param tableView <#tableView description#>
- (instancetype)initWithMoreGroupTableView:(UITableView *) tableView
                                dataSource:(NSArray *) dataSource{
    return [self initWithViewHelper:[ZNTableViewHelper new] dataLoader:[[ZNTableViewDataLoader alloc] initMoreGroupWithDataSource:dataSource] tableView:tableView];
}

/// 不用传manager对象的实例化方法
/// @param viewHelper <#viewHelper description#>
/// @param dataLoader <#dataLoader description#>
- (instancetype)initWithViewHelper:(id<ZNTableViewLayoutProtocol,
                                    ZNTableViewLunchProtocol> ) viewHelper
                        dataLoader:(id<ZNTableViewDataSourceDelegate>) dataLoader
                         tableView:(UITableView *) tableView{
    self.selfManager.viewHelper = viewHelper;
    self.selfManager.dataLoader = dataLoader;
    return [self initWithTableView:tableView manager:self.selfManager];
}

/// 当前tableview的处理对象
/// @param tableView 主tableview
/// @param manager 管理对象
- (instancetype)initWithTableView:(UITableView *) tableView
                          manager:(ZNTableViewManage *) manager{
    self.selfManager = manager;
    self.viewHelper = manager.viewHelper;
    self.dataLoader = manager.dataLoader;
    self.selfManager.registerCellModels = self.registerCellModels;
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    ///保底注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    return self;
}

- (void)addRegisterModel:(ZNRegisterModel *) model{
    if (model) {
        NSString * className = NSStringFromClass(model.cellClass);
        if (!self.registerCellModels[className]) {
            if (!model.cutsHeight) {
                model.height = ZNCellHeight;
            }
            [self.registerCellModels setObject:model forKey:className];
            [self.tableView registerClass:model.cellClass forCellReuseIdentifier:NSStringFromClass(model.cellClass)];
        }
    }
}

- (void)addRegisterModels:(NSArray<ZNRegisterModel *> *) models{
    if (models.count > 0) {
        for (ZNRegisterModel * model in models) {
            [self addRegisterModel:model];
        }
    }
}

/// 添加策略
/// @param strategyClass <#strategyClass description#>
- (void)addRegisterStrategyWithClass:(id<ZNTableViewStrategyProtocol>) strategyClass{
    NSString * className = NSStringFromClass([strategyClass class]);
    if (!self.registerStrategyModels[className]) {
        [self.registerStrategyModels setObject:strategyClass forKey:className];
    }
}

/// 刷新tableView
- (void)reload{
    ////策略执行
    for (Class<ZNTableViewStrategyProtocol> strategy in self.registerStrategyModels.allValues) {
        [self.selfManager reloadWithStrategy:strategy];
    }
    [self.tableView reloadData];
}

/// 添加事件
/// @param action <#action description#>
- (void)addAction:(id<ZNTableViewActionProtocol>) action{
    self.actionDelegate = action;
    self.selfManager.cellAction = action;
    ///挂在这里，应该是Action没有给一个 @property(nonatomic , weak) ZNTableViewKit * tableViewKit;
    self.actionDelegate.tableViewKit = self;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(didSelectItemWithCell:model:indexPath:)]) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.actionDelegate didSelectItemWithCell:cell model:[self.selfManager.dataLoader obtianObjectWithIndexPath:indexPath] indexPath:indexPath];
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selfManager && [self.selfManager respondsToSelector:@selector(managerRowHeightWithIndexPath:)]) {
        return [self.selfManager managerRowHeightWithIndexPath:indexPath];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class cellClass = nil;
    if (self.selfManager && [self.selfManager respondsToSelector:@selector(managerCellClassWithIndexPath:)]) {
        cellClass = [self.selfManager managerCellClassWithIndexPath:indexPath];
    }else{
        cellClass = [UITableViewCell class];
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
    
    if (cell == nil) {
        [ZNTableViewErrow throwWithAction:_cmd errowClass:self.class decriction:@"cell未注册" name:@"cell错误"];
    }
    
    if (self.selfManager && [self.selfManager respondsToSelector:@selector(managerLunchTableViewCell:indexPath:)]) {
        [self.selfManager managerLunchTableViewCell:cell indexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selfManager && [self.selfManager respondsToSelector:@selector(managerWillDisplayCell:forRowAtIndexPath:)]) {
        [self.selfManager managerWillDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.selfManager && [self.selfManager respondsToSelector:@selector(managerNumberOfSectionsInTableView:)]) {
        return [self.selfManager managerNumberOfSectionsInTableView:tableView];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.selfManager && [self.selfManager respondsToSelector:@selector(managerNumberOfRowsInSection:)]) {
        return [self.selfManager managerNumberOfRowsInSection:section];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.selfManager && [self.selfManager respondsToSelector:@selector(managerViewHeaderInSection:)]) {
        [self.selfManager managerViewHeaderInSection:section];
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.selfManager && [self.selfManager respondsToSelector:@selector(managerHeightForHeaderInSection:)]) {
        [self.selfManager managerHeightForHeaderInSection:section];
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.selfManager && [self.selfManager respondsToSelector:@selector(managerViewForFooterInSection:)]) {
        [self.selfManager managerViewForFooterInSection:section];
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.selfManager && [self.selfManager respondsToSelector:@selector(managerHeightForFooterInSection:)]) {
        [self.selfManager managerHeightForFooterInSection:section];
    }
    return 0.01f;
}

#pragma mark - get

- (NSMutableDictionary<NSString *,ZNRegisterModel *> *)registerCellModels{
    if (!_registerCellModels) {
        _registerCellModels = [NSMutableDictionary new];
    }
    return _registerCellModels;
}

- (NSMutableDictionary<NSString *,id<ZNTableViewStrategyProtocol>> *)registerStrategyModels{
    if (!_registerStrategyModels) {
        _registerStrategyModels = [NSMutableDictionary new];
    }
    return _registerStrategyModels;
}

- (ZNTableViewManage *)selfManager{
    if (_selfManager == nil) {
        _selfManager = [[ZNTableViewManage alloc] init];
        _selfManager.viewHelper = self.viewHelper;
        _selfManager.dataLoader = self.dataLoader;
    }
    return _selfManager;
}

@end
