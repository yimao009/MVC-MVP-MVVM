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
#import <NSObject+YYModel.h>

static NSString *const reuserId = @"reuserId";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, MainViewDelegate>

@property (nonatomic, strong, readwrite) NSMutableArray *dataArray;
@property (nonatomic, strong, readwrite) UITableView *tableView;

@property (nonatomic, strong, readwrite) MainView *headerView;
@property (nonatomic, strong, readwrite) MModel *headerModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self.view addSubview:self.tableView];
    
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
- (void)loadData
{
    NSArray *temArray =
    @[
#import "data.h"
    ];
    
    for (int i = 0; i<temArray.count; i++) {
        Model *m = [Model modelWithDictionary:temArray[i]];
        [self.dataArray addObject:m];
    }
}

#pragma mark - delegate datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserId forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - MainViewDelegate

- (void)mainView:(MainView *)mainView loadStr:(NSString *)str
{
    [self.headerModel load];
    [self presentViewController:[self alertVCTitle:@"加载成功" withMsg:str alertStyle:UIAlertControllerStyleAlert] animated:YES completion:nil];
}


#pragma mark - LAZY

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[MVTableViewCell class] forCellReuseIdentifier:reuserId];
        _tableView.rowHeight = 44.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
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

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
