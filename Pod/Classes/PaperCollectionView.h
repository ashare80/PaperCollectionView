//
//  PaperCollectionView.h
//  Pods
//
//  Created by Adam J Share on 3/20/16.
//
//

#import <UIKit/UIKit.h>
#import "RVTPaperCollectionViewController.h"


@interface PaperCollectionView : UIView

@property (strong, nonatomic) RVTPaperCollectionViewController *collectionViewController;
@property (weak, nonatomic) id<RVTPaperCollectionViewControllerDelegate> delegate;

@end