//
//  ToDoListViewController.m
//  StandMVC
//
//  Created by guoruize on 2020/7/19.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "ToDoListViewController.h"
#import "ToDoItem.h"
#import "ToDoStore.h"

static NSString * const cellIdentifier = @"ToDoItemCell";

@interface ToDoListViewController ()
@property (nonatomic, strong, readwrite) NSMutableArray<ToDoItem *> *items;
@property (nonatomic, strong, readwrite) UIBarButtonItem *addBtn;
@property (nonatomic, strong, readonly) ToDoStore *todaoStore;
@end

@implementation ToDoListViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.tabBarController.navigationItem.rightBarButtonItem.customView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
        如何避免把 Model View Controller 写成 Massive View Controller 已经是老生常谈的问题了。不管是拆分 View Controller 的功能 (使用多个 Child View Controller)，还是换用“广义”的 MVC 框架 (比如 MVVM 或者 VIPER)，又或者更激进一点，转换思路使用 Reactive 模式或 Reducer 模式，其实所想要解决的问题本质在于，我们要如何才能更清晰地管理“用户操作，模型变更，UI 反馈”这一数据流动的方式。
        参考链接 https://onevcat.com/2018/05/mvc-wrong-use/
     
     单向数据流动

     接下来，将数据流动按照 MVC 的标准进行梳理就是自然而然的事情了。我们的目标是避免 UI 行为直接影响 UI，而是由 Model 的状态通过 Controller 来确定 UI 状态。这需要我们的 Model 能够以某种“非直接”的方式向 Controller 进行汇报。按照上面的 MVC 图，我们使用 Notification 来搞定。
     */
    _items = @[].mutableCopy;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(todoItemsDidChange:) name:@"kTodoStoreDidChangedNotificationName" object:nil];
}

- (void)showRight
{
    _addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
    self.tabBarController.navigationItem.rightBarButtonItems = @[_addBtn];
}

- (ToDoStore *)todaoStore
{
    return [ToDoStore sharedInstance];
}

- (void)todoItemsDidChange:(NSNotification *)notification
{
    ChangeBehaviorModel *model = [notification.userInfo objectForKey:@"userInfo"];
    [self syncTableViewFor: model];
    [self updateAddButtonState];
}

- (void)syncTableViewFor:(ChangeBehaviorModel *)bghaviorModel
{
    
    NSMutableArray *indexs = [@[] mutableCopy];
    for (NSNumber *num in bghaviorModel.tmpIndexs) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:[num integerValue] inSection:0];
        [indexs addObject:path];
    }
    switch (bghaviorModel.bghavior) {
        case add:
            [self.tableView insertRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationNone];
            break;
        case removed:
            [self.tableView deleteRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationNone];
            break;
        case reload:
            [self.tableView reloadData];
            break;
        default:
            break;
    }
}

- (void)updateAddButtonState
{
    _addBtn.enabled = self.todaoStore.count < 10 ? YES : NO;
}

#pragma mark - Action
- (void)addButtonPressed
{
//    NSUInteger newCount = _items.count + 1;
//    NSString *title = [NSString stringWithFormat:@"ToDo Item %@", @(newCount)];
//    // 更新items
//    [_items addObject:[[ToDoItem alloc] initWithTitle:title]];
//    // 为 table view 添加新行
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newCount - 1 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    if (newCount >= 10) {
//        _addBtn.enabled = NO;
//    }
    NSInteger newCount = self.todaoStore.count + 1;
    NSString *title = [NSString stringWithFormat:@"ToDo Item %@", @(newCount)];
    [self.todaoStore append: [[ToDoItem alloc] initWithTitle:title]];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.todaoStore.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.todaoStore itemAtIndex:indexPath.row].title;
//    cell.textLabel.text = _items[indexPath.row].title;
    return cell;
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction *action, __kindof UIView *sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        // 用户确认删除，从 `items` 中移除该事项
//        [self.items removeObjectAtIndex:indexPath.row];
        // 从 table view 中移除对应行
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        // 维护 addButton 状态
//        if (self.items.count < 10) {
//            self.addBtn.enabled = YES;
//        }
        [self.todaoStore removeWithIndex:indexPath.row];
        completionHandler(YES);
    }];
    return [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
