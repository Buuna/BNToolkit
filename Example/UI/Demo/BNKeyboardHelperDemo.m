//
// Created by Daniel Rodrigues on 18/02/2014.
// Copyright (c) 2014 Buuna Pty Ltd. All rights reserved.
//

#import "BNKeyboardHelperDemo.h"

#import "BNKeyboardNotificationProxy.h"

@implementation BNKeyboardHelperDemo  {
    UIScrollView *_scrollView;
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

    //upper upperField
    UITextField *upperField = [[UITextField alloc] init];
    upperField.textColor = [UIColor blackColor];
    upperField.borderStyle = UITextBorderStyleLine;
    upperField.delegate = self;
    [contentView addSubview:upperField];
    [upperField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(contentView.left).with.offset(10);
        make.right.equalTo(contentView.right).with.offset(-10);
        make.height.equalTo(@44);
    }];

    //dummy view serving no purpose but to occupy space for scrolling
    UIView *spaceView = [[UIView alloc] init];
    spaceView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:spaceView];
    [spaceView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upperField.bottom);
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
        make.left.equalTo(contentView.left).with.offset(10);
        make.right.equalTo(contentView.right).with.offset(-10);
        make.height.equalTo(upperField.height);
    }];

    //sizing view required to determine content view size
    UIView *sizingView = [[UIView alloc] init];
    [_scrollView addSubview:sizingView];
    [sizingView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lowerField.bottom);
        make.bottom.equalTo(contentView.bottom).with.offset(-10);
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

    [[BNKeyboardNotificationProxy sharedProxy] addKeyboardOffsetObserverForScrollView:_scrollView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[BNKeyboardNotificationProxy sharedProxy] removeKeyboardOffsetObserverForScrollView:_scrollView];
}

@end