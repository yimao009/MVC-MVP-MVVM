//
//  MyImagePickerCell.m
//  StandMVC
//
//  Created by guoruize on 2020/8/6.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "MyImagePickerCell.h"
@interface CheckBox : UIButton
@end

@implementation CheckBox
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    CGFloat widthDelta = MAX(60.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(60.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}
@end

@implementation MyImagePickerCell
{
    UIImageView *_imageView;
    CheckBox *_button;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        _button = [CheckBox buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(checkBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_button setBackgroundImage:[UIImage imageNamed:@"checkmark"] forState:UIControlStateSelected];
        [_button setBackgroundImage:[UIImage imageNamed:@"checkboxBg"] forState:UIControlStateNormal];
        [self.contentView addSubview:_button];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = self.contentView.bounds;
    
    CGFloat buttonSize = 25;
    CGFloat margin = 2;
    _button.frame = CGRectMake(self.contentView.bounds.size.width - buttonSize - margin, margin, buttonSize, buttonSize);
}

- (void)setUserSelected:(BOOL)userSelected
{
    _userSelected = userSelected;
    _button.selected = _userSelected;
}

- (void)checkBoxClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerCellCheckBoxClicked:)]) {
        [self.delegate imagePickerCellCheckBoxClicked:self];
    }
}

- (void)setImage:(UIImage *)image
{
    _imageView.image = image;
}

- (UIImage *)image
{
    return _imageView.image;
}


@end
