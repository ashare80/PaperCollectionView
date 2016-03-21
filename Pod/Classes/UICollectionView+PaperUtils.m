//
//  UICollectionView+PaperUtils.m
//  Field Tech
//
//  Created by Adam J Share on 7/9/15.
//  Copyright (c) 2015 Ravti. All rights reserved.
//

#import "UICollectionView+PaperUtils.h"

@implementation UICollectionView (PaperUtils)

- (NSIndexPath *)lastIndexPath {
    
    NSInteger section = [self.dataSource numberOfSectionsInCollectionView:self] - 1;
    if (section < 0) {
        return nil;
    }
    NSInteger item = [self.dataSource collectionView:self numberOfItemsInSection:section] - 1;
    if (item < 0) {
        item = 0;
    }
    return [NSIndexPath indexPathForItem:item inSection:section];
}

@end


@implementation UIScrollView (PaperUtils)

- (CGFloat)horizontalOffset {
    return self.contentOffset.x;
}

- (void)setHorizontalOffset:(CGFloat)horizontalOffset {
    CGPoint offset = self.contentOffset;
    offset.x = horizontalOffset;
    self.contentOffset = offset;
}

@end
