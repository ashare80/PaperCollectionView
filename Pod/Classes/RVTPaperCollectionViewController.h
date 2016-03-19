//
//  RVTPaperCollectionViewController.h
//  PaperScrollView
//
//  Created by Adam J Share on 4/29/15.
//  Copyright (c) 2015 Adam J Share. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RVTPaperCollectionViewController;

@protocol RVTPaperCollectionViewControllerDelegate <NSObject>

@optional
- (void)paperCollectionViewControllerDidMinimize:(RVTPaperCollectionViewController *)controller;
- (void)paperCollectionViewControllerDidMaximize:(RVTPaperCollectionViewController *)controller;

- (void)paperCollectionViewControllerWillMinimize:(RVTPaperCollectionViewController *)controller;
- (void)paperCollectionViewControllerWillMaximize:(RVTPaperCollectionViewController *)controller;

@end

@interface RVTPaperCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) id<RVTPaperCollectionViewControllerDelegate> delegate;

@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;

@property (assign, nonatomic) CGFloat maximizedHeight;
@property (assign, nonatomic) CGFloat minimizedHeight;

@property (readonly, nonatomic) BOOL minimized;
@property (readonly, nonatomic) BOOL maximized;

@property (assign, nonatomic) BOOL shouldLayout;

- (void)minimizeCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)maximizeCellAtIndexPath:(NSIndexPath *)indexPath;

- (void)minimizeCell;
- (void)scrollToAndMaximizeIndexPath:(NSIndexPath *)indexPath;

@end


@interface PaperCollectionView : UIView

@property (strong, nonatomic) RVTPaperCollectionViewController *collectionViewController;

@end