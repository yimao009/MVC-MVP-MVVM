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
#import <Masonry.h>
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
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSAVE) name:@"saveSucessful" object:nil];
    
//    [self testContentHugging];
//    [self testMasonryConstraints];
}

// 制造冲突
- (void)testMasonryConstraints
{
    UIView *v1 = [UIView new];
    v1.backgroundColor = [UIColor redColor];
    MASAttachKeys(v1);
//    v1.mas_key = @"guoruize";
    [self.view addSubview:v1];
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(60);
        make.size.mas_equalTo(CGSizeMake(70, 90));
    }];
    
}

// 练习Content Hugging 和 Content Compression Resistance
- (void)testContentHugging
{
    // Conteng Hugging
    // 表示抗被拉伸的优先级 默认250 优先级越高 越不容易被拉伸
    // Content Compression
    // 抗压缩 优先级越高 越不容易压缩 默认750
    
    // 练习
    /**
     如果你想去练习一下，我建议你用自动布局去实现一下新浪微博首页的Cell，或者微信朋友圈的Cell。
     */
    UILabel* leftLabel = [[UILabel alloc] init];
    leftLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:leftLabel];
    leftLabel.text = @"人做的畜生之事越多，内心越是痛苦。床前明月光";
    [leftLabel sizeToFit];
    
    UILabel* rightLabel = [[UILabel alloc] init];
    rightLabel.backgroundColor = [UIColor greenColor];
    [self.view addSubview:rightLabel];
    rightLabel.text = @"1234567890";
    [rightLabel sizeToFit];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20));
        make.left.equalTo(self.view).offset(10);
        make.centerY.equalTo(self.view);
        make.right.mas_lessThanOrEqualTo(rightLabel.mas_left);
    }];
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20));
        make.left.mas_greaterThanOrEqualTo(leftLabel.mas_right);
        make.right.equalTo(self.view).offset(-10);
        make.centerY.equalTo(leftLabel);
    }];
    
    [leftLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"StandMVC://"]];
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
