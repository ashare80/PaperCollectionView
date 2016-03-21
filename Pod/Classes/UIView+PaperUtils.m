//
//  UIView+PaperUtils.m
//  TapShield
//
//  Created by Adam Share on 2/18/14.
//  Copyright (c) 2014 TapShield, LLC. All rights reserved.
//

#import "UIView+PaperUtils.h"

@implementation UIView (PaperUtils)

- (UIView *)findFirstResponder {
    if ([self isFirstResponder])
        return self;
    
    for (UIView * subView in self.subviews) {
        UIView * firstResponder = [subView findFirstResponder];
        if (firstResponder != nil)
            return firstResponder;
    }
    
    return nil;
}


- (CGPoint)contentCenter {
    
    return CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (NSArray<NSLayoutConstraint *>*)autoPinToSuperView {
    
    UIView *childView = self;
    UIView *superView = self.superview;
    
    childView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:superView
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:childView
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1
                                                                constant:0];
    [superView addConstraint:leading];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:superView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:childView
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1
                                                            constant:0];
    [superView addConstraint:top];
    
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:superView
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:childView
                                                                attribute:NSLayoutAttributeTrailing
                                                               multiplier:1
                                                                 constant:0];
    [superView addConstraint:trailing];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:superView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:childView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0];
    [superView addConstraint:bottom];
    
    return @[leading, top, trailing, bottom];
}

@end
