//
// Created by Daniel Rodrigues on 18/02/2014.
// Copyright (c) 2014 Buuna Pty Ltd. All rights reserved.
//

#import "BNKeyboardHelperDemo.h"

#import "BNKeyboardHelper.h"

#import "BNUtil.h"

@implementation BNKeyboardHelperDemo  {
    UIScrollView *_scrollView;
}

- (id)init {
    if((self = [super init])) {
        self.title = @"BNKeyboardHelperDemo";
    }

    return self;
}

//Apple TN2154
//https://developer.apple.com/library/ios/technotes/tn2154/_index.html

//Masonry example:
//https://github.com/cloudkite/Masonry/blob/master/Examples/Masonry%20iOS%20Examples/MASExampleScrollView.m

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];

    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    //content view that all scrolling subviews must be added to
    UIView *contentView = [[UIView alloc] init];
    [_scrollView addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView.width);
    }];

    //upper field
    UITextField *field = [[UITextField alloc] init];
    field.textColor = [UIColor blackColor];
    field.borderStyle = UITextBorderStyleLine;
    field.delegate = self;
    [contentView addSubview:field];
    [field makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(contentView.width);
        make.height.equalTo(@20);
    }];

    //dummy view serving no purpose but to occupy space for scrolling
    UIView *spaceView = [[UIView alloc] init];
    spaceView.backgroundColor = [UIColor orangeColor];
    [contentView addSubview:spaceView];
    [spaceView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(field.bottom);
        make.left.equalTo(@0);
        make.width.equalTo(contentView.width);
        make.height.equalTo(@600);
    }];

    //"Scroll down!"
    UILabel *spaceLabel = [[UILabel alloc] init];
    spaceLabel.textColor = [UIColor blackColor];
    spaceLabel.text = @"Scroll down!";
    [contentView addSubview:spaceLabel];
    [spaceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(spaceView);
    }];

    //lower field
    UITextField *lowerField = [[UITextField alloc] init];
    lowerField .textColor = [UIColor blackColor];
    lowerField .borderStyle = UITextBorderStyleLine;
    lowerField .delegate = self;
    [contentView addSubview:lowerField ];
    [lowerField  makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spaceView.bottom);
        make.left.equalTo(@0);
        make.width.equalTo(contentView.width);
        make.height.equalTo(@20);
    }];

    //sizing view required to determine content view size
    UIView *sizingView = [[UIView alloc] init];
    [_scrollView addSubview:sizingView];
    [sizingView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lowerField.bottom);
        make.bottom.equalTo(contentView.bottom);
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

//TODO: refactor this into reusable blob (provide helper method with scrollview instance...)
- (void)_keyboardWillShow:(NSNotification *)note {
    UIScrollView *scrollView = _scrollView;

    UIView *firstResponder = BNFindFirstResponder(scrollView);
    [BNKeyboardHelper adjustContentInsetOfScrollView:(scrollView) withAdditionalAnimations:nil forKeyboardNotification:note];
}

- (void)_keyboardWillHide:(NSNotification *)note {
    [BNKeyboardHelper adjustContentInsetOfScrollView:_scrollView forKeyboardNotification:note];
}

@end