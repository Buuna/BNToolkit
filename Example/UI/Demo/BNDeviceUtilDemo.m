//
// Created by Daniel Rodrigues on 17/02/2014.
// Copyright (c) 2014 Buuna Pty Ltd. All rights reserved.
//

#import "BNDeviceUtilDemo.h"

#import "BNDeviceUtil.h"

@implementation BNDeviceUtilDemo

- (id)init {
    if((self = [super init])) {
        self.title = @"BNDeviceUtil";
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];

    BNDeviceUtil *util = [BNDeviceUtil sharedUtil];
    NSMutableString *output = [NSMutableString string];
    [output appendFormat:@"Retina: %@\n", (util.isRetina ? @"Yes" : @"No")];
    [output appendFormat:@"4-inch: %@\n", (util.is4Inch ? @"Yes" : @"No")];
    [output appendFormat:@"Dimensions: %@\n", NSStringFromCGSize(util.screenSize)];

    UILabel *outputLabel = [[UILabel alloc] init];
    outputLabel.textColor = [UIColor blackColor];
    outputLabel.numberOfLines = 0;
    outputLabel.text = output;

    [self.view addSubview:outputLabel];
    [outputLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

@end