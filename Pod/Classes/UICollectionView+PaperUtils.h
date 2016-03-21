//
//  UICollectionView+PaperUtils.h
//  Field Tech
//
//  Created by Adam J Share on 7/9/15.
//  Copyright (c) 2015 Ravti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (PaperUtils)

@property (readonly, nonatomic) NSIndexPath *lastIndexPath;

@end


@interface UIScrollView (PaperUtils)

@property (assign, nonatomic) CGFloat horizontalOffset;

@end
