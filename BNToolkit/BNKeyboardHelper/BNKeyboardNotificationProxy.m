//
// Created by Daniel Rodrigues on 19/02/2014.
// Copyright (c) 2014 Buuna Pty Ltd. All rights reserved.
//

#import "BNKeyboardNotificationProxy.h"

#import "BNKeyboardHelper.h"

@interface BNKeyboardNotificationProxyContainer : NSObject

@property (nonatomic) UIScrollView *scrollView;

@end

@implementation BNKeyboardNotificationProxyContainer

+ (instancetype)containerWithScrollView:(UIScrollView *)scrollView {
    return [[[self class] alloc] initWithScrollView:scrollView];
}

- (id)initWithScrollView:(UIScrollView *)scrollView {
    if((self = [super init])) {
        _scrollView = scrollView;
    }

    return self;
}

- (BOOL)isEqual:(id)object {
    if(![object isMemberOfClass:[self class]])
        return NO;

    return (self.scrollView == ((BNKeyboardNotificationProxyContainer *)(object)).scrollView);
}

- (NSUInteger)hash {
    return (NSUInteger)self.scrollView;
}


@end

//////////

@interface BNKeyboardNotificationProxy ()

@property (nonatomic) NSMutableSet *observers;

@end

@implementation BNKeyboardNotificationProxy

static BNKeyboardNotificationProxy *_sharedProxy;

+ (void)initialize {
    _sharedProxy = [[[self class] alloc] init];
}

+ (instancetype)sharedProxy {
    return _sharedProxy;
}

- (id)init {
    if((self = [super init])) {
        _observers = [NSMutableSet set];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillAppearOrDisappear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillAppearOrDisappear:) name:UIKeyboardWillHideNotification object:nil];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addKeyboardOffsetObserverForScrollView:(UIScrollView *)scrollView {
    [self.observers addObject:[BNKeyboardNotificationProxyContainer containerWithScrollView:scrollView]];
}

- (void)removeKeyboardOffsetObserverForScrollView:(UIScrollView *)scrollView {
    [self.observers removeObject:[BNKeyboardNotificationProxyContainer containerWithScrollView:scrollView]];
}

- (void)_keyboardWillAppearOrDisappear:(NSNotification *)note {
    [self.observers enumerateObjectsUsingBlock:^(BNKeyboardNotificationProxyContainer *container, BOOL *stop) {
        [BNKeyboardHelper adjustContentInsetOfScrollView:(container.scrollView) forKeyboardNotification:note];
    }];
}

@end