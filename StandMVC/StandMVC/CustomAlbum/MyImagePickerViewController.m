//
//  MyImagePickerViewController.m
//  StandMVC
//
//  Created by guoruize on 2020/8/4.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "MyImagePickerViewController.h"
#import "MyImagePickAlbumsTableViewController.h"
#import "MyImagePreviewViewController.h"
#import "MyImagePickerCell.h"
#import "PHAsset+FetchImage.h"
#import <Photos/Photos.h>

static const CGFloat itemSpacing = 5;
static const NSUInteger itemPerRow = 4;

@interface MyImagePickerViewController ()<MyImagePickAlbumsTableViewControllerDelegate, MyImagePickerCellDelegate, MyImagePreviewViewControllerDelegate,PHPhotoLibraryChangeObserver>
{
    NSMutableArray <PHAssetCollection *>*_albums;
    NSMutableArray <PHFetchResult <PHAssetCollection *> *> *_albumResults;
    PHFetchResult <PHAsset *> * _assets;
    NSMutableArray <PHAsset *> *_selectedAsstes;
}
@property (nonatomic, strong, readwrite) PHAssetCollection *currentAlbum;
@end

@implementation MyImagePickerViewController

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - dealloc & init

- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (instancetype)init
{
    CGFloat size = ([[UIScreen mainScreen] bounds].size.width - itemSpacing * (itemPerRow + 1)) / itemPerRow;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(size, size);
    layout.sectionInset = UIEdgeInsetsMake(itemSpacing, 0, 0, 0);
    layout.minimumInteritemSpacing = itemSpacing;
    layout.minimumLineSpacing = itemSpacing;
    
    self = [self initWithCollectionViewLayout:layout];
    if (self)
    {
        _albums             = [[NSMutableArray alloc] init];
        _albumResults       = [NSMutableArray array];
        _selectedAsstes     = [NSMutableArray array];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"albums" style:UIBarButtonItemStylePlain target:self action:@selector(albumsAction:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Finish" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction:)];
    }
    return self;
}

#pragma mark - navigation item Actions
- (void)albumsAction:(id)sender
{
    if (_albums.count == 0) return;
    
    MyImagePickAlbumsTableViewController *albumsViewController = [[MyImagePickAlbumsTableViewController alloc] initWithAssetCollections:_albums];
    albumsViewController.delegate = self;
    [self.navigationController pushViewController:albumsViewController animated:YES];
}

- (void)finishAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerViewController:didSelectAssets:)])
    {
        [self.delegate imagePickerViewController:self didSelectAssets:[_selectedAsstes copy]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.backgroundView = nil;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, itemSpacing, 0, itemSpacing);
    
    [self.collectionView registerClass:[MyImagePickerCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self requestAuthorization:^(PHAuthorizationStatus status) {
        // 主线程问题
        [self performSelectorOnMainThread:@selector(requestAuthorizationFinished:) withObject:@(status) waitUntilDone:NO];
    }];
}

#pragma mark - permission
- (void)requestAuthorization:(void(^)(PHAuthorizationStatus status))handler
{
    // 1.1 获取权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined)
    {
        [PHPhotoLibrary  requestAuthorization:handler];
    }
    else if(handler)
    {
        handler(status);
    }
}
- (void)requestAuthorizationFinished:(NSNumber *)status
{
    if ([status integerValue] == PHAuthorizationStatusAuthorized)
    {
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        // load album
        [self reloadAlbums];
    }
    else
    {
        // handler error
    }
}
#pragma mark - albums
- (void)loadAlbums:(void(^)(void))finished
{
    [_albums removeAllObjects];
    [_albumResults removeAllObjects];
    // 读取相册列表
    PHFetchResult<PHAssetCollection *> *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [result enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj)
        {
            [self->_albums addObject:obj];
        }
    }];
    if (result)
    {
        [_albumResults addObject:result];
    }
    result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    [result enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj)
        {
            [self->_albums addObject:obj];
        }
    }];
    if (result)
    {
        [_albumResults addObject:result];
    }
    if (finished)
    {
        finished();
    }
}

- (void)reloadAlbums
{
    [self loadAlbums:^{
        self.currentAlbum = [_albums firstObject];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _assets.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *asset = [_assets objectAtIndex:indexPath.item];
    MyImagePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.image = [asset fi_aspectThumbnailImageWithSize:[(UICollectionViewFlowLayout *)collectionView.collectionViewLayout itemSize]];
    cell.userSelected = [_selectedAsstes containsObject:asset];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    PHAsset *asset = _assets[indexPath.item];
    MyImagePreviewViewController *previewViewController = [[MyImagePreviewViewController alloc] initWithAsset:asset];
    previewViewController.delegate = self;
    [self.navigationController pushViewController:previewViewController animated:YES];
}

#pragma mark - MyImagePreviewViewControllerDelegate
- (void)imagePreviewViewController:(MyImagePreviewViewController *)imagePreviewViewController
{
    [self selectOrDeselectAsset:imagePreviewViewController.asset];
}

#pragma mark - MyImagePickerCellDelegate
- (void)imagePickerCellCheckBoxClicked:(MyImagePickerCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self selectOrDeselectAsset:[_assets objectAtIndex:indexPath.item]];
}

- (void)selectOrDeselectAsset:(PHAsset *)asset
{
    if ([_selectedAsstes containsObject:asset])
    {
        [_selectedAsstes removeObject:asset];
    }
    else
    {
        [_selectedAsstes addObject:asset];
    }
    [self.collectionView reloadData];
}

#pragma mark - MyImagePickAlbumsTableViewControllerDelegate
- (void)imagePickAAlbumsViewController:(MyImagePickAlbumsTableViewController *)imagePickAlbumsViewcController didSelectAlbum:(PHAssetCollection *)album
{
    self.currentAlbum = album;
}

#pragma mark - setter
- (void)setCurrentAlbum:(PHAssetCollection *)currentAlbum
{
    if (_currentAlbum == currentAlbum)
    {
        return;
    }
    _currentAlbum = currentAlbum;
    self.navigationItem.title = _currentAlbum.localizedTitle;
    //load assets
    [self reloadAssets];
}

#pragma mark - assets
- (void)loadAssets:(void(^)(void))finished
{
    if (!_currentAlbum)
    {
        if (finished)
        {
            finished();
        }
        return;
    }
    [_selectedAsstes removeAllObjects];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i", PHAssetMediaTypeImage];
    _assets = [PHAsset fetchAssetsInAssetCollection:_currentAlbum options:options];
    if (finished)
    {
        finished();
    }
}

- (void)reloadAssets
{
    // 去后台做事情
    [self performSelectorInBackground:@selector(doReloadAssets) withObject:nil];
}

- (void)doReloadAssets
{
    //返回主线程
    [self loadAssets:^{
        [self performSelectorOnMainThread:@selector(reloadAssetsFinished) withObject:nil waitUntilDone:NO];
    }];
}

- (void)reloadAssetsFinished
{
    [self.collectionView reloadData];
}

#pragma mark - change
- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    BOOL shouldReloadAlbum = NO;
    for (PHFetchResult <PHAssetCollection *>*result in _albumResults)
    {
        PHFetchResultChangeDetails *change = [changeInstance changeDetailsForFetchResult:result];
        if (change)
        {
            shouldReloadAlbum = YES;
            break;
        }
    }
    if (shouldReloadAlbum)
    {
        [self reloadAlbums];
    }
    else
    {
        [self reloadAssets];
    }
}
@end
