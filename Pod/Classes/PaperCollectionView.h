//
//  PaperCollectionView.h
//  Pods
//
//  Created by Adam J Share on 3/20/16.
//
//

#import <UIKit/UIKit.h>
#import "PaperCollectionViewController.h"


@interface PaperCollectionView : UIView

@property (strong, nonatomic) PaperCollectionViewController *collectionViewController;
@property (weak, nonatomic) id<PaperCollectionViewControllerDelegate> delegate;

@end