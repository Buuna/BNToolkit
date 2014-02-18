//
//  BNKeyboardHelper.m
//
//  Created by Scott Talbot on 28/03/11.
//  Copyright 2011 Wunderman. All rights reserved.
//

#import "BNKeyboardHelper.h"


static UIViewAnimationOptions UIViewAnimationCurveOption(UIViewAnimationCurve curve) {
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
    }
    return 0;
}


@implementation BNKeyboardHelper

+ (NSTimeInterval)animationDurationFromKeyboardNotification:(NSNotification *)notification {
    NSTimeInterval animationDuration;
    [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    return animationDuration;
}

+ (UIViewAnimationCurve)animationCurveFromKeyboardNotification:(NSNotification *)notification {
    UIViewAnimationCurve animationCurve;
    [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    return animationCurve;
}

+ (UIViewAnimationOptions)animationOptionCurveFromKeyboardNotification:(NSNotification *)notification {
    return UIViewAnimationCurveOption([self animationCurveFromKeyboardNotification:notification]);
}

+ (void)resizeView:(UIView *)view forKeyboardNotification:(NSNotification *)notification {
    [self resizeView:view withAdditionalAnimations:nil forKeyboardNotification:notification];
}
+ (void)resizeView:(UIView *)view withAdditionalAnimations:(void(^)())animations forKeyboardNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;

    UIViewAnimationCurve animationCurve;
    NSTimeInterval animationDuration;

    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];

    CGFloat yDisplacement;

    id keyboardFrameBeginObj = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    id keyboardFrameEndObj = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];

    CGRect keyboardFrameBegin, keyboardFrameEnd;
    [keyboardFrameBeginObj getValue:&keyboardFrameBegin];
    [keyboardFrameEndObj getValue:&keyboardFrameEnd];
    yDisplacement = keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y;

    [UIView animateWithDuration:animationDuration delay:0
                        options:UIViewAnimationCurveOption(animationCurve)|UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGRect frame = view.frame;
                         frame.size.height -= yDisplacement;
                         view.frame = frame;
                         if (animations)
                             animations();
                     }
                     completion:nil];
}

+ (void)adjustContentInsetOfScrollView:(UIScrollView *)scrollView forKeyboardNotification:(NSNotification *)notification {
    [self adjustContentInsetOfScrollView:scrollView withAdditionalAnimations:nil withScrollViewBottomOffset:0 forKeyboardNotification:notification];
}
+ (void)adjustContentInsetOfScrollView:(UIScrollView *)scrollView withAdditionalAnimations:(void (^)())animations forKeyboardNotification:(NSNotification *)notification {
    [self adjustContentInsetOfScrollView:scrollView withAdditionalAnimations:animations withScrollViewBottomOffset:0 forKeyboardNotification:notification];
}
+ (void)adjustContentInsetOfScrollView:(UIScrollView *)scrollView withAdditionalAnimations:(void (^)())animations withScrollViewBottomOffset:(CGFloat)bottomOffset
               forKeyboardNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;

    UIViewAnimationCurve animationCurve;
    NSTimeInterval animationDuration;

    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];

    CGFloat yDisplacement;

    id keyboardFrameBeginObj = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    id keyboardFrameEndObj = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];

    CGRect keyboardFrameBegin, keyboardFrameEnd;
    [keyboardFrameBeginObj getValue:&keyboardFrameBegin];
    [keyboardFrameEndObj getValue:&keyboardFrameEnd];
    //NOTE: these do NOT take into account rotation so x/y must be swapped in landscape mode
    yDisplacement = (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])
                     ? keyboardFrameBegin.origin.x - keyboardFrameEnd.origin.x
                     : keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y);
    if (yDisplacement > 0) {
        yDisplacement -= bottomOffset;
    } else if (yDisplacement < 0) {
        yDisplacement += bottomOffset;
    }

//    if (yDisplacement) {
        UIEdgeInsets contentInset = scrollView.contentInset;
        UIEdgeInsets scrollIndicatorInsets = scrollView.scrollIndicatorInsets;

        contentInset.bottom += yDisplacement;
        scrollIndicatorInsets.bottom += yDisplacement;

        [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationCurveOption(animationCurve)|UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionBeginFromCurrentState animations:^{
            scrollView.contentInset = contentInset;
            scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
            if (animations)
                animations();
        } completion:nil];
//    }
}

+ (void)ensureRect:(CGRect)rect visibleInScrollView:(UIScrollView *)scrollView forKeyboardNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;

    CGFloat yDisplacement;

    id keyboardFrameBeginObj = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    id keyboardFrameEndObj = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];

    CGRect keyboardFrameBegin, keyboardFrameEnd;
    [keyboardFrameBeginObj getValue:&keyboardFrameBegin];
    [keyboardFrameEndObj getValue:&keyboardFrameEnd];
    yDisplacement = keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y;

    if (yDisplacement) {
        [scrollView scrollRectToVisible:rect animated:YES];
    }
}

@end
