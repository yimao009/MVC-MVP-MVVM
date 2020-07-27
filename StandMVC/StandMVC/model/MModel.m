//
//  MModel.m
//  MVCDemo
//
//  Created by guoruize on 2020/5/30.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "MModel.h"

@implementation MModel

- (void)save
{
    // 通知 vc
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSucessful" object:nil];
    NSLog(@"保存成功");
}

- (void)load
{
    NSLog(@"加载。。。。");
}

@end
