//
//  MyImagePickAlbumsTableViewController.m
//  StandMVC
//
//  Created by guoruize on 2020/8/6.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "MyImagePickAlbumsTableViewController.h"
#import "PHAssetCollection+Poster.h"
#import <Photos/Photos.h>

@interface MyImageAlbumCell : UITableViewCell

@end

@implementation MyImageAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat margin = 10;
    self.imageView.frame = CGRectMake(margin, 0, self.contentView.bounds.size.height, self.contentView.bounds.size.height);
    self.separatorInset = UIEdgeInsetsMake(0, margin * 2 + self.contentView.bounds.size.height, 0, 0);
    self.textLabel.frame = CGRectMake(margin * 2 + self.contentView.bounds.size.height, 0, self.textLabel.frame.size.width, self.contentView.bounds.size.height);
}

@end

@interface MyImagePickAlbumsTableViewController ()
{
    NSArray <PHAssetCollection *> *_albums;
}
@end

@implementation MyImagePickAlbumsTableViewController

- (instancetype)initWithAssetCollections:(NSArray<PHAssetCollection *> *)assetCollections
{
    if (self = [self initWithStyle:UITableViewStylePlain])
    {
        _albums = [assetCollections copy];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style])
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Actions

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"albumCell";
    MyImageAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[MyImageAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = _albums[indexPath.row].localizedTitle;
    cell.imageView.image = [_albums[indexPath.row] pi_poster];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(imagePickAAlbumsViewController:didSelectAlbum:)])
    {
        [self.delegate imagePickAAlbumsViewController:self didSelectAlbum:_albums[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
