//
//  MyImagePickerCell.h
//  StandMVC
//
//  Created by guoruize on 2020/8/6.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyImagePickerCell;

NS_ASSUME_NONNULL_BEGIN

@protocol MyImagePickerCellDelegate <NSObject>
@optional
- (void)imagePickerCellCheckBoxClicked:(MyImagePickerCell *_Nullable)cell;
@end

@interface MyImagePickerCell : UICollectionViewCell
@property (nonatomic, weak) id<MyImagePickerCellDelegate> delegate;
@property (nonatomic, strong, readwrite) UIImage *image;
@property (nonatomic, assign, readwrite) BOOL userSelected;
@end

NS_ASSUME_NONNULL_END
