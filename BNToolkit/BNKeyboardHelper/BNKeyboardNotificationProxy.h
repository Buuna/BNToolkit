//
// Created by Daniel Rodrigues on 19/02/2014.
// Copyright (c) 2014 Buuna Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNKeyboardNotificationProxy : NSObject

+ (instancetype)sharedProxy;

/**
* Adds a scroll view to the list of views that are automatically offset and resized when the keyboard appears.
* This should normally be called in the viewDidAppear: method of the scroll view's parent view controller.
*/
- (void)addKeyboardOffsetObserverForScrollView:(UIScrollView *)scrollView;

/**
*  Removes a scroll view from the list of views that are automatically offset and resized when the keyboard appears.
*  This should normally be called in the viewWillDisappear: method of the scroll view's parent view controller.
*/
- (void)removeKeyboardOffsetObserverForScrollView:(UIScrollView *)scrollView;

@end