//
//  PaperCollectionViewController.m
//  PaperScrollView
//
//  Created by Adam J Share on 4/29/15.
//  Copyright (c) 2015 Adam J Share. All rights reserved.
//

#import "PaperCollectionViewController.h"
#import "PaperCell.h"
#import "UIView+PaperUtils.h"
#import <pop/POP.h>
#import "PaperView.h"
#import "UICollectionView+PaperUtils.h"



@interface PaperCollectionViewController ()

@property (assign, nonatomic) BOOL paperPagingEnabled;

//Pan
@property (strong, nonatomic) UIPanGestureRecognizer *paperPanGestureRecognizer;

@property (strong, nonatomic) NSIndexPath *panBeganIndexPath;
@property (readonly, nonatomic) NSIndexPath *pagingIndexPath;

@property (assign, nonatomic) CGFloat initialRatioXInCell;
@property (assign, nonatomic) CGFloat initialRatioYInCell;
@property (assign, nonatomic) CGFloat initialOffset;
@property (assign, nonatomic) CGFloat initialHeight;
@property (assign, nonatomic) CGPoint pointInWindow;
@property (assign, nonatomic) CGPoint startOffset;
@property (assign, nonatomic) CGPoint endOffset;

@property (assign, nonatomic) CGFloat maximizedSpacing;

//Size

//Default to screen height

@property (readonly, nonatomic) CGSize currentCellSize;
@property (readonly, nonatomic) CGFloat viewWidth;
@property (readonly, nonatomic) CGFloat scale;
@property (readonly, nonatomic) CGFloat minimizedScale;
@property (readonly, nonatomic) CGFloat spacing;
@property (readonly, nonatomic) CGFloat height;
@property (readonly, nonatomic) CGFloat margin;
@property (readonly, nonatomic) CGFloat maxOffsetMinimized;
@property (readonly, nonatomic) CGFloat maxOffsetMaximized;

//MaxMin

@property (readonly, nonatomic) BOOL shouldMaximize;

@property (readonly, nonatomic) BOOL maximizing;
@property (readonly, nonatomic) BOOL minimizing;
@property (readonly, nonatomic) BOOL animating;

@property (nonatomic) BOOL shouldFollowEndOffsetPath;

@end

@implementation PaperCollectionViewController

static NSString * const reuseIdentifier = @"PaperCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _maximizedSpacing = 8;
    
    self.collectionView.clipsToBounds = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.collectionView registerClass:[PaperCell class]forCellWithReuseIdentifier:reuseIdentifier];
    
    ((UICollectionViewFlowLayout *)self.collectionViewLayout).scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self addPanGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addPanGesture {
    _paperPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    _paperPanGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_paperPanGestureRecognizer];
}


#pragma mark - Getter/Setter

- (CGRect)cellFrameForIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellX = indexPath.item*self.currentCellSize.width + indexPath.item*self.spacing + [self collectionView:self.collectionView layout:self.collectionViewLayout insetForSectionAtIndex:0].left;
    CGPoint origin = CGPointMake(cellX, 0.0);
    
    return (CGRect){.origin = origin, .size = self.currentCellSize};
}

- (NSIndexPath *)pagingIndexPath {
    
    CGFloat offsetX = self.collectionView.contentOffset.x;
    
    UICollectionViewCell *closestCell;
    CGFloat shortestDistance = MAXFLOAT;
    
    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        
        CGFloat center = cell.frame.size.width/2 + cell.frame.origin.x;
        CGFloat offsetCenter = offsetX + self.viewWidth/2;
        
        CGFloat distance = fabs(center-offsetCenter);
        if (distance<shortestDistance) {
            shortestDistance = distance;
            closestCell = cell;
        }
    }
    
    if (!closestCell) {
        return nil;
    }
    
    return [self.collectionView indexPathForCell:closestCell];
}

- (CGFloat)spacing {
    return [self spacingForScale:self.scale];
}

- (CGFloat)spacingForScale:(CGFloat)scale {
    return _maximizedSpacing * scale;
}

- (CGFloat)margin {
    return [self marginForScale:self.scale];
}

- (CGFloat)marginForScale:(CGFloat)scale {
    
    CGFloat distance = self.maximizedHeight - self.minimizedHeight;
    CGFloat difference = self.maximizedHeight * scale - self.minimizedHeight;
    
    if (difference >= distance) {
        return 0;
    }
    
    if (difference <= 0) {
        return [self spacingForScale:scale];
    }
    
    CGFloat x = (1 - difference / distance) * [self spacingForScale:scale];
    return x;
}

- (CGFloat)scale {
    
    return _height/self.maximizedHeight;
}

- (CGFloat)minimizedScale {
    
    return _minimizedHeight/self.maximizedHeight;
}

- (CGSize)currentCellSize {
    
    CGSize size = CGSizeZero;
    
    size.height = _height;
    size.width = self.viewWidth * self.scale;
    
    return size;
}

- (CGFloat)maximizedHeight {
    if (_maximizedHeight <= 0 || _maximizedHeight <= self.minimizedHeight) {
        _maximizedHeight = [UIScreen mainScreen].bounds.size.height;
    }
    
    return _maximizedHeight;
}

- (CGFloat)viewWidth {
    
    return self.view.frame.size.width;
}

- (BOOL)minimized {
    
    return _height == _minimizedHeight;
}

- (BOOL)maximized {
    
    return _height == self.maximizedHeight;
}

- (BOOL)shouldMaximize {
    
    return (self.maximizedHeight-self.minimizedHeight)/2 < self.height-self.minimizedHeight;
}

- (void)setHeightConstraint:(NSLayoutConstraint *)heightConstraint {
    
    _heightConstraint = heightConstraint;
    
    _minimizedHeight = heightConstraint.constant;
    self.height = _minimizedHeight;
}

- (void)setHeight:(CGFloat)height {
    
    height = round(height * 5.0) / 5.0;
    
    [self.collectionViewLayout invalidateLayout];
    
    _height = height;
    _heightConstraint.constant = height+.2;
    
    if (_shouldLayout) {
        [self.view.superview layoutIfNeeded];
    }
    
    self.collectionView.contentOffset = [self adjustedContentOffset];
    
    if ([self.delegate respondsToSelector:@selector(paperViewHeightDidChange:percentMaximized:)]) {
        CGFloat percent = (height - self.minimizedHeight) / (self.maximizedHeight - self.minimizedHeight);
        if (percent > 1) {
            percent = 1;
        } else if (percent < 0) {
            percent = 0;
        }
        [self.delegate paperViewHeightDidChange:_height percentMaximized:percent];
    }
}

- (CGFloat)offsetAtIndex:(NSUInteger)index forScale:(CGFloat)scale {
    
    return index * self.viewWidth * scale + index * [self spacingForScale:scale] + [self marginForScale:scale];
}

- (CGFloat)maxOffsetMaximized {
    
    return [self maxOffsetForScale:self.scale];
}

- (CGFloat)maxOffsetMinimized {
    
    return [self maxOffsetForScale:self.minimizedScale];
}

- (CGFloat)maxOffsetForScale:(CGFloat)scale {
    
    return floor([self offsetAtIndex:self.collectionView.lastIndexPath.item forScale: scale] - (self.viewWidth - self.viewWidth * scale) + [self marginForScale:scale]);
}

#pragma mark - Pan Gesture


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == _paperPanGestureRecognizer)
    {
        CGRect contentRect = CGRectMake(0.0, self.view.frame.size.height-self.currentCellSize.height, self.view.frame.size.width, self.currentCellSize.height);
        
        CGPoint locationInView = [gestureRecognizer locationInView:self.view];
        return CGRectContainsPoint(contentRect, locationInView);
    }
    
    return YES;
}

- (void)handlePan:(UIPanGestureRecognizer *)panGesture {
    
    _pointInWindow = [panGesture locationInView:[UIApplication sharedApplication].delegate.window];
    
    CGPoint translation = [panGesture translationInView:self.view];
    
    CGFloat changeY = _initialOffset - translation.y;
    
    CGFloat yRatioOffset = 1+_initialRatioYInCell;
    CGFloat endHeight = _initialHeight+ changeY * yRatioOffset;
    
    CGPoint gestureVelocity = [panGesture velocityInView:self.view];
    
    //bounce down
    CGFloat bounceHeight = 100;
    if (endHeight < _minimizedHeight) {
        CGFloat difference = _minimizedHeight-endHeight;
        
        if (difference > 0) {
            CGFloat ratio = 1-(difference/_minimizedHeight);
            if (ratio < 0) {
                ratio = 0;
            }
            difference = bounceHeight * (1 - ratio*ratio);
        }
        
        endHeight = _minimizedHeight-difference;
    } else if (endHeight > self.maximizedHeight) {
        CGFloat difference = endHeight-_maximizedHeight;
        
        if (difference > 0) {
            CGFloat ratio = 1-(difference/_maximizedHeight);
            if (ratio < 0) {
                ratio = 0;
            }
            difference = bounceHeight * (1 - ratio*ratio);
        }
        
        endHeight = _maximizedHeight+difference;
    }
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan: {
            
            [self pop_removeAllAnimations];
            [self.collectionView pop_removeAllAnimations];
            
            _animating = NO;
            
            _initialOffset = translation.y;
            _initialHeight = _height;
            
            CGPoint pointInCollection = [panGesture locationInView:self.collectionView];
            _panBeganIndexPath = [self.collectionView indexPathForItemAtPoint:pointInCollection];
            
            if (!_panBeganIndexPath) {
                NSUInteger index = floor(pointInCollection.x/(self.currentCellSize.width+self.spacing));
                _panBeganIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
            }
            
            if (_panBeganIndexPath) {
                UICollectionViewCell *highlightedCell = [self.collectionView cellForItemAtIndexPath:_panBeganIndexPath];
                if (!highlightedCell) {
                    _initialRatioXInCell = 0;
                }
                else {
                    _initialRatioXInCell = [panGesture locationInView:highlightedCell].x/highlightedCell.frame.size.width;
                    _initialRatioYInCell = [panGesture locationInView:highlightedCell].y/highlightedCell.frame.size.height;
                }
            }
            
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            self.height = endHeight;
            break;
        }
            
        default: {
            CGFloat velocityThresh = 1500;
            
            if ((self.shouldMaximize && gestureVelocity.y < velocityThresh) || gestureVelocity.y < -velocityThresh) {
                [self maximizeCellAtIndexPath:self.pagingIndexPath velocity:gestureVelocity.y];
            }
            else {
                [self minimizeCellAtIndexPath:self.pagingIndexPath velocity:gestureVelocity.y];
            }
            
            break;
        }
    }
}

- (CGPoint)adjustedContentOffset {
    
    CGPoint contentOffset = self.collectionView.contentOffset;
    
    if (self.animating && _shouldFollowEndOffsetPath) {
        CGFloat distance = _startOffset.y-_endOffset.y;
        CGFloat yDifference = distance - ((self.maximizedHeight - _height) - _endOffset.y);
        CGFloat xDifference = _endOffset.x-_startOffset.x;
        CGFloat ratio = yDifference/distance;
        
        contentOffset.x = _startOffset.x + xDifference * ratio;
        return contentOffset;
    }
    
    CGFloat panPositionX = _pointInWindow.x;
    CGFloat panPositionOffset = panPositionX + contentOffset.x;
    
    
    CGFloat cellX = _panBeganIndexPath.item*self.currentCellSize.width + _panBeganIndexPath.item * self.spacing + [self collectionView:self.collectionView layout:self.collectionViewLayout insetForSectionAtIndex:0].left;
    CGFloat cellXPoint = cellX + _initialRatioXInCell * self.currentCellSize.width;
    
    CGFloat adjustment = cellXPoint - panPositionOffset;
    
    contentOffset.x += adjustment;
    return contentOffset;
}


#pragma mark <UICollectionViewLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.currentCellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0.0, self.margin, 0.0, self.margin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return self.spacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return self.spacing;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.minimized) {
        [self maximizeCellAtIndexPath:indexPath];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (_paperPagingEnabled) {
        [self.collectionView pop_removeAllAnimations];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (_paperPagingEnabled) {
        
        CGFloat currentOffset = self.collectionView.contentOffset.x;
        
        BOOL bouncing = (currentOffset < 0 || currentOffset > self.maxOffsetMaximized);
        BOOL bounceTarget = targetContentOffset->x <= 0 || targetContentOffset->x >= self.maxOffsetMaximized;
        if (bouncing && bounceTarget) {
            return;
        }
        
        CGFloat page = currentOffset / (self.currentCellSize.width + self.spacing);
        targetContentOffset->x = scrollView.contentOffset.x;
        
        
        if (velocity.x > 1) {
            page = ceilf(page);
        }
        else if (velocity.x < -1) {
            page = floor(page);
        }
        else {
            page = roundf(page);
        }
        
        if (page < 0) {
            page = 0;
        }
        CGFloat pageOffsetX = page * (self.currentCellSize.width + self.spacing) + self.margin;
        CGPoint scrollOffset = scrollView.contentOffset;
        scrollOffset.x = pageOffsetX;
        
        [self.collectionView pop_removeAllAnimations];
        POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
        POPAnimatableProperty *property = [POPAnimatableProperty propertyWithName:@"offset" initializer:^(POPMutableAnimatableProperty *prop) {
            prop.readBlock = ^(id obj, CGFloat values[]) {
                values[0] = [obj horizontalOffset];
            };
            prop.writeBlock = ^(id obj, const CGFloat values[]) {
                [obj setHorizontalOffset:values[0]];
            };
            prop.threshold = 0.01;
        }];
        
        if (velocity.x != 0) {
            springAnimation.velocity = @(fabs(velocity.x));
        }
        
        springAnimation.springSpeed = 20;
        springAnimation.property = property;
        springAnimation.fromValue = @(currentOffset);
        springAnimation.toValue = @(scrollOffset.x);
        springAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        };
        [self.collectionView pop_addAnimation:springAnimation forKey:NSStringFromSelector(@selector(horizontalOffset))];
    }
}

#pragma mark - Animations

- (void)scrollToAndMaximizeIndexPath:(NSIndexPath *)indexPath {
    
    if (self.maximized) {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        return;
    }
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    } completion:^(BOOL finished) {
        [self maximizeCellAtIndexPath:indexPath];
    }];
}

- (void)maximizeCellAtIndexPath:(NSIndexPath *)indexPath  {
    
    _panBeganIndexPath = indexPath;
    _pointInWindow = self.view.center;
    _initialRatioXInCell = .5;
    _initialRatioYInCell = .5;
    
    [self maximizeCellAtIndexPath:indexPath velocity:0];
}

- (void)maximizeCellAtIndexPath:(NSIndexPath *)indexPath velocity:(CGFloat)velocity  {
    
    [self pop_removeAllAnimations];
    
    _paperPagingEnabled = YES;
    
    _startOffset = self.collectionView.contentOffset;
    _startOffset.y = self.maximizedHeight - _height;
    _endOffset = CGPointMake((self.viewWidth + self.maximizedSpacing) * indexPath.item, 0);
    
    if (self.maximizedHeight == _height) {
        [self.collectionView setContentOffset:_endOffset animated:YES];
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(paperViewWillMaximize:)]) {
        [_delegate paperViewWillMaximize:(PaperView *)self.collectionView.superview];
    }
    
    _shouldFollowEndOffsetPath = YES;
    [self animateFromHeight:_height toScaledHeight:self.maximizedHeight velocity:velocity completion:^(BOOL finished) {
        _shouldFollowEndOffsetPath = NO;
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }];
}

- (void)minimizeCell {
    
    [self minimizeCellAtIndexPath:self.pagingIndexPath];
}

- (void)minimizeCellAtIndexPath:(NSIndexPath *)indexPath {
    
    [self minimizeCellAtIndexPath:indexPath velocity:0];
}

- (void)minimizeCellAtIndexPath:(NSIndexPath *)indexPath velocity:(CGFloat)velocity {
    
    [[self.view findFirstResponder] resignFirstResponder];
    [self pop_removeAllAnimations];
    
    _paperPagingEnabled = NO;
    
    _startOffset = self.collectionView.contentOffset;
    _startOffset.y = self.maximizedHeight - _height;
    
    CGFloat offsetX = [self offsetAtIndex:indexPath.item forScale:self.minimizedScale];
    offsetX -= (self.viewWidth/2 - (self.viewWidth*self.minimizedScale)/2);
    
    CGFloat maxOffset = self.maxOffsetMinimized;
    
    _shouldFollowEndOffsetPath = NO;
    
    if (offsetX < 0) {
        offsetX = 0;
        _shouldFollowEndOffsetPath = YES;
    }
    else if (offsetX > maxOffset) {
        offsetX = maxOffset;
        _shouldFollowEndOffsetPath = YES;
    }
    
    _endOffset = CGPointMake(offsetX, self.maximizedHeight - _minimizedHeight);
    
    if ([_delegate respondsToSelector:@selector(paperViewWillMinimize:)]) {
        [_delegate paperViewWillMinimize:(PaperView *)self.collectionView.superview];
    }
    
    [self animateFromHeight:_height toScaledHeight:_minimizedHeight velocity:0 completion:^(BOOL finished) {
        _shouldFollowEndOffsetPath = NO;
    }];
}

- (void)animateFromHeight:(CGFloat)height toScaledHeight:(CGFloat)scaledHeight velocity:(CGFloat)velocity completion:(void (^)(BOOL finished)) completion {
    
    _animating = YES;
    self.collectionView.scrollEnabled = NO;
    
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    POPAnimatableProperty *property = [POPAnimatableProperty propertyWithName:@"minimize" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.readBlock = ^(id obj, CGFloat values[]) {
            values[0] = [obj height];
        };
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            [obj setHeight:values[0]];
        };
        prop.threshold = 0.01;
    }];
    
    if (velocity != 0) {
        springAnimation.velocity = @(fabs(velocity));
    }
    
    springAnimation.springSpeed = 20;
    springAnimation.property = property;
    springAnimation.fromValue = @(height);
    springAnimation.toValue = @(scaledHeight);
    springAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        
        _animating = NO;
        
        self.collectionView.scrollEnabled = YES;
        
        if (finished) {
            if (scaledHeight == _minimizedHeight) {
                if ([_delegate respondsToSelector:@selector(paperViewDidMinimize:)]) {
                    [_delegate paperViewDidMinimize:(PaperView *)self.collectionView.superview];
                }
            }
            else {
                if ([_delegate respondsToSelector:@selector(paperViewDidMaximize:)]) {
                    [_delegate paperViewDidMaximize:(PaperView *)self.collectionView.superview];
                }
            }
            if (completion) {
                completion(YES);
            }
        }
    };
    [self pop_addAnimation:springAnimation forKey:NSStringFromSelector(@selector(height))];
}

@end
