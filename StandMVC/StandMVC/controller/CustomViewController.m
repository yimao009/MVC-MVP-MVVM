//
//  CustomViewController.m
//  StandMVC
//
//  Created by xuzheng on 2020/7/27.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "CustomViewController.h"
#import "ToDoListViewController.h"
#import "ViewController.h"
@interface CustomViewController ()<UITabBarControllerDelegate>

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    NSMutableArray *btns = [tabBarController.navigationItem.rightBarButtonItems mutableCopy];
    
    if (tabBarController.selectedIndex == 0)
    {
        ViewController *vc = (ViewController *)viewController;
        [vc hideRight];
    }
    else if(tabBarController.selectedIndex == 1)
    {
        ToDoListViewController *vc = (ToDoListViewController *)viewController;
        [vc showRight];
    }
}

@end
