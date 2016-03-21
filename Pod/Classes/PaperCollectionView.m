//
//  PaperCollectionView.m
//  Pods
//
//  Created by Adam J Share on 3/20/16.
//
//

#import "PaperCollectionView.h"
#import "UIView+PaperUtils.h"

@interface PaperCollectionView ()

@end

@implementation PaperCollectionView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.clipsToBounds = NO;
    self.collectionViewController = [[PaperCollectionViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    [self addSubview:self.collectionViewController.view];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (NSLayoutConstraint *con in self.constraints) {
        if (con.firstAttribute == NSLayoutAttributeHeight) {
            self.collectionViewController.shouldLayout = NO;
            self.collectionViewController.heightConstraint = con;
            self.collectionViewController.shouldLayout = YES;
        }
    }
    self.collectionViewController.view.frame = self.bounds;
    [self.collectionViewController.view autoPinToSuperView];
}

- (void)setDelegate:(id<PaperCollectionViewControllerDelegate>)delegate {
    _delegate = delegate;
    _collectionViewController.delegate = delegate;
}

@end