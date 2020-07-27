//
//  MVTableViewCell.m
//  MVCDemo
//
//  Created by guoruize on 2020/6/16.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "MVTableViewCell.h"
#import <Masonry.h>
@implementation MVTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.numLabel];
    [self.contentView addSubview:self.addBtn];
    [self.contentView addSubview:self.subBtn];
    self.num = 0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(20);
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-50);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.addBtn.mas_left);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    [self.subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numLabel.mas_left);
        make.size.centerY.equalTo(self.addBtn);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - setter
- (void)setNum:(int)num
{
    _num = num;
    self.numLabel.text = [@(num) stringValue];
//    在这里修改数据，反应UI的操作 （第一种方式）
//    self.model.num = self.numLabel.text;
}

#pragma mark - LAZY
- (UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.text = @"0";
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.font = [UIFont systemFontOfSize:20];
        _numLabel.textColor = [UIColor redColor]  ;
    }
    return _numLabel;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"Co";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:20];
        _nameLabel.textColor = [UIColor cyanColor]  ;
    }
    return _nameLabel;
}

- (UIButton *)subBtn
{
    if (!_subBtn) {
        _subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_subBtn setTitle:@"-" forState:UIControlStateNormal];
        [_subBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _subBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_subBtn setBackgroundColor:UIColor.cyanColor];
        _subBtn.layer.cornerRadius = 15;
        _subBtn.layer.masksToBounds = YES;
        _subBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _subBtn;
}

- (UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setTitle:@"+" forState:UIControlStateNormal];
        [_addBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_addBtn setBackgroundColor:UIColor.cyanColor];
        _addBtn.layer.cornerRadius = 15;
        _addBtn.layer.masksToBounds = YES;
        _addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _addBtn;
}

@end
