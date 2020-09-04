//
//  ViewController.m
//  MVVM
//
//  Created by guoruize on 2020/6/17.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "ViewController.h"
#import "MVVMViewModel.h"
#import "MVVMView.h"
#import "LoginViewController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

static NSString *const reuserId = @"reuserId";
/*
    MVVM：

       1、双向绑定：
           model -》UI      block 逆向传值
           UI -》model     使用 KVO 响应式
*/
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong, readwrite) MVVMViewModel *vm;
@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *array = @[
               @"转账", @"信用卡", @"充值中心", @"蚂蚁借呗", @"电影票",
               @"滴滴出行", @"城市服务", @"蚂蚁森林"
           ];
    [self.dataArray addObjectsFromArray:array];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
//    MVVMView *headView = [[MVVMView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (array.count + 1)/4*50)];
//    [headView headViewWithData:array];
//    self.tableView.tableHeaderView = headView;
    
    
    self.vm = [[MVVMViewModel alloc] init];
    __weak typeof(self) weakSelf = self;
    // 异步请求   -- block
    [self.vm initWithBlock:^(id data) {
        // 绑定：block（data） -》UI
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSArray *array = data;
        MVVMView *headView = [[MVVMView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (array.count + 1)/4*50)];
        [headView headViewWithData:array];
        strongSelf.tableView.tableHeaderView = headView;
        [strongSelf.dataArray removeAllObjects];
        [strongSelf.dataArray addObjectsFromArray:array];
        [strongSelf.tableView reloadData];
    } fail:nil];
  
//    self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(reResh)];
}

#pragma mark - Action
// UI --> model --> UI
// model --> UI ---> model
- (IBAction)clickReload:(id)sender
{
    NSLog(@"clickReload 点我刷新数据");
    [self.vm loadData];
}
- (void)reResh
{
    NSLog(@"reResh 点我刷新数据");
    [self.vm loadData];
}

#pragma mark - tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserId forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        LoginViewModel *loginViewModel = [[LoginViewModel alloc] initWithParams:@{@"title":@"MVMV"}];
        LoginViewController *loginVC = [[LoginViewController alloc] initWithViewModel:loginViewModel];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.vm.contentKey = self.dataArray[indexPath.row];
}

#pragma mark - Lazy

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuserId];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _dataArray;
}
@end
