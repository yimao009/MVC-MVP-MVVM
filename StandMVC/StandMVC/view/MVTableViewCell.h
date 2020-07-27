//
//  MVTableViewCell.h
//  MVCDemo
//
//  Created by guoruize on 2020/6/16.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface MVTableViewCell : UITableViewCell

@property (nonatomic, strong, readwrite) UIButton *subBtn;
@property (nonatomic, strong, readwrite) UILabel *nameLabel;
@property (nonatomic, strong, readwrite) UILabel *numLabel;
@property (nonatomic, strong, readwrite) UIButton *addBtn;

@property (nonatomic, assign, readwrite) int num;
@property (nonatomic, strong, readwrite) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
