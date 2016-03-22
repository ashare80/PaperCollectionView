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
@class PaperView;

@protocol PaperViewDelegate <NSObject>

@optional
- (void)paperViewDidMinimize:(PaperView *)view;
- (void)paperViewDidMaximize:(PaperView *)view;

- (void)paperViewWillMinimize:(PaperView *)view;
- (void)paperViewWillMaximize:(PaperView *)view;

- (void)paperViewHeightDidChange:(CGFloat)height percentMaximized:(CGFloat)percent;

@end

@interface PaperCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) id<PaperViewDelegate> delegate;

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
