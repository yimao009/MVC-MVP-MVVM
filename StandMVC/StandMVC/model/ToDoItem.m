//
//  ToDoItem.m
//  StandMVC
//
//  Created by guoruize on 2020/7/19.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "ToDoItem.h"
#import <UIKit/UIKit.h>
@interface ToDoItem ()
@property (nonatomic, copy, readwrite) NSString *uid;

@end

@implementation ToDoItem
- (instancetype)initWithTitle:(NSString *)title
{
    if(self = [super init]) {
        self.uid = [UIDevice currentDevice].systemVersion;
        self.title = title;
    }
    return self;
}
@end
