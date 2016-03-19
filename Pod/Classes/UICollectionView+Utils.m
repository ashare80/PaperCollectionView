//
//  UICollectionView+Utils.m
//  Field Tech
//
//  Created by Adam J Share on 7/9/15.
//  Copyright (c) 2015 Ravti. All rights reserved.
//

#import "UICollectionView+Utils.h"

@implementation UICollectionView (Utils)

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
