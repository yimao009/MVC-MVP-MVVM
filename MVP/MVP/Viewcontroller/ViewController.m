//
//  ViewController.m
//  NormalMVC
//
//  Created by guoruize on 2020/6/17.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"
#import "MModel.h"
#import "MainView.h"
#import "MVTableViewCell.h"
#import "Present.h"
#import "DataSourceMager.h"

static NSString *const reuserId = @"reuserId";

@interface ViewController ()<MainViewDelegate, PresentDelegate>

@property (nonatomic, strong, readwrite) NSMutableArray *dataArray;
@property (nonatomic, strong, readwrite) UITableView *tableView;

@property (nonatomic, strong, readwrite) MainView *headerView;
@property (nonatomic, strong, readwrite) MModel *headerModel;
@property (nonatomic, strong, readwrite) Present *pt;
@property (nonatomic, strong, readwrite) DataSourceMager *dt;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 数据提供层
    self.pt = [[Present alloc] init];
    
    // 代理逻辑层封装
    __weak typeof(self) weakSelf = self;
    self.dt = [[DataSourceMager alloc] initWithIdentifier:reuserId configureBlock:^(MVTableViewCell * cell, Model * model, NSIndexPath * _Nonnull indexPath) {
        // 避免提前释放
        __strong typeof(weakSelf) strongSelf = weakSelf;
//        cell.model = model;
        cell.delegate = strongSelf.pt;
        cell.indexPath = indexPath;
        cell.numLabel.text = model.num;
        cell.nameLabel.text = model.name;
    } selectBlock:^(NSIndexPath * _Nonnull indexPath) {
        NSLog(@"%@", @(indexPath.row));
    }];
    // tableview
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self.dt;
    self.tableView.delegate = self.dt;
    [self.dt addDataArray:self.pt.dataArray];
    self.pt.delegate = self;
    
    // MVP 面向协议编程 以协议作为主体， 协议驱动代码
    // POP swift  协议 扩展
    // 关系 - block 函数 协议 指针 通知

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSAVE) name:@"saveSucessful" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification 

- (void)notificationSAVE
{
    [self presentViewController:[self alertVCTitle:@"保存成功" withMsg:@"lalala" alertStyle:UIAlertControllerStyleAlert] animated:YES completion:nil];
}

#pragma mark - load data

#pragma mark - delegate datasource

#pragma mark - MainViewDelegate

- (void)mainView:(MainView *)mainView loadStr:(NSString *)str
{
    [self.headerModel load];
    [self presentViewController:[self alertVCTitle:@"加载成功" withMsg:str alertStyle:UIAlertControllerStyleAlert] animated:YES completion:nil];
}

#pragma mark - PresentDelegate
- (void)reloadDataForUI
{
    [self.dt addDataArray:self.pt.dataArray];
    [self.tableView reloadData];
}

#pragma mark - LAZY

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[MVTableViewCell class] forCellReuseIdentifier:reuserId];
        _tableView.rowHeight = 44.0;
//        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (MainView *)headerView
{
    if (!_headerView) {
        _headerView = [[MainView alloc] init];
        _headerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
        _headerView.delegate = self;
        __weak typeof(self) waekSelf = self;
        _headerView.saveBlock = ^{
            [waekSelf.headerModel save];
        };
    }
    return _headerView;
}

- (MModel *)headerModel
{
    if (!_headerModel) {
        _headerModel = [[MModel alloc] init];
    }
    return _headerModel;
}


- (UIAlertController *)alertVCTitle:(nonnull NSString *)title withMsg:(nullable NSString *)msg alertStyle:(UIAlertControllerStyle)style
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:style];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    return alert;
}

@end
