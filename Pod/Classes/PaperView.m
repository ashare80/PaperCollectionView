//
//  PaperView.m
//  Pods
//
//  Created by Adam J Share on 3/20/16.
//
//

#import "PaperView.h"
#import "UIView+PaperUtils.h"

@interface PaperView ()

@end

@implementation PaperView

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

- (void)addShadow {
    
    self.collectionViewController.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionViewController.collectionView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.collectionViewController.collectionView.layer.shadowOffset = CGSizeMake(0, 3);
    self.collectionViewController.collectionView.layer.shadowOpacity = 0.2;
    self.collectionViewController.collectionView.layer.shadowRadius = 2;
}

- (void)setDelegate:(id<PaperViewDelegate>)delegate {
    _delegate = delegate;
    _collectionViewController.delegate = delegate;
}

- (void)setDatasource:(id<UICollectionViewDataSource>)datasource {
    _datasource = datasource;
    _collectionViewController.collectionView.dataSource = datasource;
}

- (void)setParentViewController:(UIViewController *)parentViewController {
    _parentViewController = parentViewController;
    [parentViewController addChildViewController:_collectionViewController];
    [_collectionViewController didMoveToParentViewController:parentViewController];
}

@end