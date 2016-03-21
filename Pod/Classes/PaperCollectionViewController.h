//
//  PaperCollectionViewController.h
//  PaperScrollView
//
//  Created by Adam J Share on 4/29/15.
//  Copyright (c) 2015 Adam J Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaperCell.h"

@class PaperCollectionViewController;

@protocol PaperCollectionViewControllerDelegate <NSObject>

@optional
- (void)PaperCollectionViewControllerDidMinimize:(PaperCollectionViewController *)controller;
- (void)PaperCollectionViewControllerDidMaximize:(PaperCollectionViewController *)controller;

- (void)PaperCollectionViewControllerWillMinimize:(PaperCollectionViewController *)controller;
- (void)PaperCollectionViewControllerWillMaximize:(PaperCollectionViewController *)controller;

- (void)didDequeuePaperCellForReuse:(PaperCell *)cell;

@end

@interface PaperCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) id<PaperCollectionViewControllerDelegate> delegate;

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
