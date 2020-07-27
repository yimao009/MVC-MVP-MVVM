//
//  MVTableViewCell.h
//  MVCDemo
//
//  Created by guoruize on 2020/6/16.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"


NS_ASSUME_NONNULL_BEGIN

@interface MVTableViewCell : UITableViewCell

@property (nonatomic, strong, readwrite) UIButton *subBtn;
@property (nonatomic, strong, readwrite) UILabel *nameLabel;
@property (nonatomic, strong, readwrite) UILabel *numLabel;
@property (nonatomic, strong, readwrite) UIButton *addBtn;

@property (nonatomic, assign, readwrite) int num;
@property (nonatomic, strong, readwrite) Model *model;

// 第二种 方式 响应UI操作
@property (nonatomic, strong, readwrite) void(^addBlock)(void);
@property (nonatomic, strong, readwrite) void(^subBlock)(void);

@end

NS_ASSUME_NONNULL_END
