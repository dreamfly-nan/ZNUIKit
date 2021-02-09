//
//  ZNTableViewKit.m
//  ZNTableViewKit
//
//  Created by apple on 2020/7/24.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ZNTableViewKit.h"
#import "ZNTableViewErrow.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>

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

@property(nonatomic , strong) id<ZNTableViewDataSourceProtocol> dataLoader;

/// 事件管理
@property(nonatomic , strong) id<ZNTableViewActionProtocol> actionDelegate;

/// cell的注册数据模型
@property(nonatomic , strong) NSMutableDictionary<NSString *, ZNRegisterModel *> *registerCellModels;

///策略
@property(nonatomic , strong) NSMutableDictionary<NSString *, id<ZNTableViewStrategyProtocol> > * registerStrategyModels;

///tableview的背景View
@property(nonatomic , strong) UIView * backgroundView;

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
                        dataLoader:(id<ZNTableViewDataSourceProtocol>) dataLoader
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
    self.tableView.backgroundView = self.backgroundView;
    self.selfManager.tableView = tableView;
    
    ///保底注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    @weakify(self);
    self.dataLoader.loadFinishBlock = ^(NSError * error,BOOL isLastPage) {
        @strongify(self)
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hiddenLoadView];
            [self.selfManager.headRefresh endRefreshing];
            if (isLastPage) {
                [self.selfManager.footerRefresh endRefreshingWithNoMoreData];
            }else{
                [self.selfManager.footerRefresh endRefreshing];
            }
            
            if (error) {
                self.selfManager.errorView.hidden = NO;
                self.selfManager.loadView.hidden = YES;
                self.selfManager.emptyView.hidden = YES;
            }else{
                self.selfManager.errorView.hidden = YES;
            }
            [self reload];
            
            if (self.ZNDelegate && [self.ZNDelegate respondsToSelector:@selector(loadDataFinish)]) {
                [self.ZNDelegate loadDataFinish];
            }
            
        });
        
    };
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

/// 添加事件
/// @param action <#action description#>
- (void)addAction:(id<ZNTableViewActionProtocol>) action{
    self.actionDelegate = action;
    self.selfManager.cellAction = action;
    ///挂在这里，应该是Action没有给一个 @property(nonatomic , weak) ZNTableViewKit * tableViewKit;
    self.actionDelegate.tableViewKit = self;
}

/// 空视图与错误视图的接入
/// @param emptyView <#emptyView description#>
- (void)setEmptyView:(UIView*) emptyView{
    self.selfManager.emptyView = emptyView;
    [self.backgroundView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backgroundView);
    }];
}

/// 错误视图接入
/// @param errorView <#errorView description#>
- (void)setErrorView:(UIView *) errorView{
    self.selfManager.errorView = errorView;
    [self.backgroundView addSubview:errorView];
    [errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backgroundView);
    }];
}

/// 加载图接入
/// @param loadView <#loadView description#>
- (void)setLoadView:(UIView *) loadView{
    self.selfManager.loadView = loadView;
    [self.backgroundView addSubview:loadView];
    [loadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backgroundView);
    }];
}

/// 注册头部
/// @param header <#header description#>
- (void)registerRefreshHead:(MJRefreshHeader *) header{
    self.tableView.mj_header = header;
    self.selfManager.headRefresh = header;
    @weakify(self);
    [header setRefreshingBlock:^{
        @strongify(self);
        [self.dataLoader loadData:YES];
    }];
}

/// 注册尾部
/// @param footer <#footer description#>
- (void)registerRefreshFoot:(MJRefreshFooter *) footer{
    self.tableView.mj_footer = footer;
    self.selfManager.footerRefresh = footer;
    @weakify(self);
    [footer setRefreshingBlock:^{
        @strongify(self);
        [self.dataLoader loadData:NO];
    }];
}

- (void)loadData:(BOOL) isReSetData{
    [self showLoadView];
    [self.dataLoader loadData:isReSetData];
}

///展示加载
- (void)showLoadView{
    self.selfManager.loadView.hidden = NO;
    self.selfManager.errorView.hidden = YES;
    self.selfManager.emptyView.hidden = YES;
}

//隐藏加载视图
- (void)hiddenLoadView{
    self.selfManager.loadView.hidden = YES;
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
        return [self.selfManager managerViewHeaderInSection:section];
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.selfManager && [self.selfManager respondsToSelector:@selector(managerHeightForHeaderInSection:)]) {
        return [self.selfManager managerHeightForHeaderInSection:section];
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.selfManager && [self.selfManager respondsToSelector:@selector(managerViewForFooterInSection:)]) {
        return [self.selfManager managerViewForFooterInSection:section];
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.selfManager && [self.selfManager respondsToSelector:@selector(managerHeightForFooterInSection:)]) {
        return [self.selfManager managerHeightForFooterInSection:section];
    }
    return 0.01f;
}

#pragma mark - ZNTableViewKitProtocol

/// 刷新tableView
- (void)reload{
    ////策略执行
    for (Class<ZNTableViewStrategyProtocol> strategy in self.registerStrategyModels.allValues) {
        [self.selfManager reloadWithStrategy:strategy];
    }
    [self.tableView reloadData];
}

/// 获取数据源
- (id<ZNTableViewDataSourceProtocol>)getDataLoader{
    return self.selfManager.dataLoader;
}

/// 获取当前的Tableview
- (UITableView *)getCurrentTableView{
    return self.tableView;
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

- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
    }
    return _backgroundView;
}


@end
