//
// Created by Daniel Rodrigues on 17/02/2014.
// Copyright (c) 2014 Buuna Pty Ltd. All rights reserved.
//

#import "BNDemoMenu.h"

#import "BNDeviceUtilDemo.h"
#import "BNKeyboardHelperDemo.h"

@interface BNDemoMenu () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    NSArray *_options;
}

@end

@implementation BNDemoMenu

- (id)init {
    if((self = [super init] )) {
        self.title = @"Demo";

        _options = @[
                @"BNDeviceUtil", [BNDeviceUtilDemo class],
                @"BNKeyboardHelper", [BNKeyboardHelperDemo class]
        ];
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor clearColor];

    //tableview with demo selection list
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;

    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_options count] / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _options[(NSUInteger)(indexPath.row * 2 + 0)];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class demoClass = _options[(NSUInteger)(indexPath.row * 2 + 1)];
    UIViewController *demoVC = [[demoClass alloc] init];
    [self.navigationController pushViewController:demoVC animated:YES];
}


@end