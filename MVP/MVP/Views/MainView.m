//
//  MainView.m
//  MVCDemo
//
//  Created by guoruize on 2020/5/30.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "MainView.h"

@interface MainView ()


@end

@implementation MainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:({
        _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn1 setTitle:@"保存" forState:UIControlStateNormal];
        [_btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _btn1.backgroundColor = [UIColor yellowColor];
        [_btn1 addTarget:self action:@selector(_saveClick) forControlEvents:UIControlEventTouchUpInside];
        _btn1;
    })];
    
    [self addSubview:({
        _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn2 setTitle:@"加载" forState:UIControlStateNormal];
        [_btn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _btn2.backgroundColor = [UIColor greenColor];
        [_btn2 addTarget:self action:@selector(_loadClick) forControlEvents:UIControlEventTouchUpInside];
        _btn2;
    })];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _btn1.frame = CGRectMake(0, 0, 100, 50);
    _btn1.center = self.center;

    CGRect tmpR = _btn1.frame;
    _btn2.frame = CGRectMake(tmpR.origin.x, tmpR.origin.y + 60, tmpR.size.width, tmpR.size.height);

}

#pragma mark - Actions
- (void)_loadClick
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(mainView:loadStr:)])
    {
        [self.delegate mainView:self loadStr:@"Test"];
    }
}

- (void)_saveClick
{
    if (self.saveBlock)
    {
        self.saveBlock();
    }
}

@end
