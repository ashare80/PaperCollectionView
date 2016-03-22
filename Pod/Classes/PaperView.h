//
//  PaperView.h
//  Pods
//
//  Created by Adam J Share on 3/20/16.
//
//

#import <UIKit/UIKit.h>
#import "PaperCollectionViewController.h"


@interface PaperView : UIView

@property (strong, nonatomic) PaperCollectionViewController *collectionViewController;
@property (weak, nonatomic) IBOutlet id<PaperViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet id<UICollectionViewDataSource> datasource;
@property (weak, nonatomic) IBOutlet UIViewController *parentViewController;

- (void)addShadow;

@end