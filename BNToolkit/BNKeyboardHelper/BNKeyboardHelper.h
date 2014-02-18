//
//  BNKeyboardHelper.h
//
//  Created by Scott Talbot on 28/03/11.
//  Copyright 2011 Wunderman. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BNKeyboardHelper : NSObject

+ (NSTimeInterval)animationDurationFromKeyboardNotification:(NSNotification *)notification;
+ (UIViewAnimationCurve)animationCurveFromKeyboardNotification:(NSNotification *)notification;
+ (UIViewAnimationOptions)animationOptionCurveFromKeyboardNotification:(NSNotification *)notification;

+ (void)resizeView:(UIView *)view forKeyboardNotification:(NSNotification *)notification;
+ (void)resizeView:(UIView *)view withAdditionalAnimations:(void(^)())animations forKeyboardNotification:(NSNotification *)notification;

+ (void)adjustContentInsetOfScrollView:(UIScrollView *)scrollView forKeyboardNotification:(NSNotification *)notification;
+ (void)adjustContentInsetOfScrollView:(UIScrollView *)scrollView withAdditionalAnimations:(void(^)())animations forKeyboardNotification:(NSNotification *)notification;
+ (void)adjustContentInsetOfScrollView:(UIScrollView *)scrollView withAdditionalAnimations:(void (^)())animations withScrollViewBottomOffset:(CGFloat)bottomOffset
               forKeyboardNotification:(NSNotification *)notification;

+ (void)ensureRect:(CGRect)rect visibleInScrollView:(UIScrollView *)scrollView forKeyboardNotification:(NSNotification *)notification;

@end
