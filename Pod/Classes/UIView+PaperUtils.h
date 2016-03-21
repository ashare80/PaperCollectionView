//
//  UIView+PaperUtils.h
//  TapShield
//
//  Created by Adam Share on 2/18/14.
//  Copyright (c) 2014 TapShield, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PaperUtils)

- (UIView *)findFirstResponder;
- (CGPoint)contentCenter;
- (NSArray<NSLayoutConstraint *>*)autoPinToSuperView;

@end
