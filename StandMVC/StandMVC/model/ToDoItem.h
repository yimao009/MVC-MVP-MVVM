//
//  ToDoItem.h
//  StandMVC
//
//  Created by guoruize on 2020/7/19.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToDoItem : NSObject
@property (nonatomic, copy, readonly) NSString *uid;
@property (nonatomic, copy, readwrite) NSString *title;
- (instancetype)initWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
