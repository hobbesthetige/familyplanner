//
//  NXPhotoArrayTableViewCell.m
//  NXMedia
//
//  Created by Joe Sferrazza on 4/3/15.
//  Copyright (c) 2015 Nexcom. All rights reserved.
//

#import "NXPhotoArrayTableViewCell.h"
#import "NXPhotoCollectionViewCell.h"
#import <NXUIKit/NXUIKit-Swift.h>

@interface NXPhotoArrayTableViewCell () <UICollectionViewDataSource>
@property (nonatomic, weak) IBOutlet UICollectionView *photoCollectionView;
@end

NSString * const NXPhotoArrayTableViewCellIdentifier = @"PhotosCell";

@implementation NXPhotoArrayTableViewCell

+ (instancetype)dequeueCell {
    UITableViewController *tableViewController = [[UIStoryboard photoStoryboard] instantiateViewControllerWithIdentifier:@"PhotosTableView"];
    return [tableViewController.tableView dequeueReusableCellWithIdentifier:NXPhotoArrayTableViewCellIdentifier];
}

- (void)awakeFromNib {
    self.photoCollectionView.dataSource = self;
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Custom Accessors
- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    [self.photoCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NXPhotoCollectionViewCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:NXPhotoCollectionViewCellIdentifier forIndexPath:indexPath];
    photoCell.photo = [self.photos objectAtIndex:indexPath.row];
    typeof(self) __weak weakSelf = self;
    if (self.deleteBlock) {
        [photoCell setDeleteBlock:^(UIImage *imageToDelete) {
            // Run the table view's delete block so it can remove this photo from it's array
            if (weakSelf.deleteBlock) {
                weakSelf.deleteBlock(imageToDelete);
            }
        }];
    }
    // Pass the enlarge block down to the cell
    [photoCell setActionBlock:self.enlargeBlock];
    return photoCell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}
@end
