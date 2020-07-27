//
//  MVVMView.m
//  MVVM
//
//  Created by guoruize on 2020/7/12.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "MVVMView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

 #define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
 #define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@implementation MVVMView

- (void)headViewWithData:(id)data
{
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:4];
    dataArray = data;
    for (int i = 0; i<dataArray.count; i++) {
        
        int row = i % 4;
        int loc = i / 4;
        CGFloat btnW = SCREEN_WIDTH/4;
        CGFloat btnH = 50;
        CGFloat btnX = row*btnW;
        CGFloat btnY = loc*btnH;

        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:dataArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:randomColor];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}


#pragma mark - action

- (void)didClickBtn:(UIButton *)sender{
    
    NSInteger tag = sender.tag - 1000;
    
    NSLog(@"%zd",tag);
    
}

#pragma mark - private

/**
 通过颜色获得图片
 */
- (UIImage *)createImageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
    
}
@end
