//
// Created by Daniel Rodrigues on 18/02/2014.
// Copyright (c) 2014 Buuna Pty Ltd. All rights reserved.
//

#import "BNKeyboardHelperDemo.h"

#import "BNKeyboardHelper.h"

#import "BNUtil.h"

@interface BNKeyboardHelperDemo () <UITextFieldDelegate>

@end

@implementation BNKeyboardHelperDemo  {
    UIScrollView *_scrollView;
    BOOL _keyboardVisible;
}

- (id)init {
    if((self = [super init])) {
        self.title = @"BNKeyboardHelperDemo";
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];

    UITextField *field = [[UITextField alloc] init];
    field.textColor = [UIColor blackColor];
    field.borderStyle = UITextBorderStyleLine;
    field.delegate = self;

    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    //TODO: figure out appropriate settings for AutoLayout
    [_scrollView addSubview:field];
    [field makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Lifecycle keyboard hooks

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Keyboard handling

- (void)_keyboardWillShow:(NSNotification *)note {
    UIScrollView *scrollView = _scrollView;

    UIView *firstResponder = BNFindFirstResponder(scrollView);
    [BNKeyboardHelper adjustContentInsetOfScrollView:(scrollView) withAdditionalAnimations:^{
        if (firstResponder) {
            CGPoint contentOffset = BNScrollViewContentOffsetToCenterRect(scrollView, [scrollView convertRect:firstResponder.bounds fromView:firstResponder]);
            contentOffset.x = 0;
            if (contentOffset.y < 0) {
                contentOffset.y = 0;
            }

            contentOffset.y = MIN(contentOffset.y,
            scrollView.contentSize.height - scrollView.contentInset.bottom + 22);
            [scrollView setContentOffset:contentOffset animated:YES];
        }
    } forKeyboardNotification:note];

    _keyboardVisible = YES;
}

- (void)_keyboardWillHide:(NSNotification *)note {
    [BNKeyboardHelper adjustContentInsetOfScrollView:_scrollView forKeyboardNotification:note];

    _keyboardVisible = NO;
}

@end