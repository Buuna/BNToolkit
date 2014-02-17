//
//  BNDeviceUtil.m
//
//
//  Created by Daniel Rodrigues on 27/06/13.
//  Copyright (c) 2013 Buuna Pty Ltd. All rights reserved.
//

#import "BNDeviceUtil.h"

@implementation BNDeviceUtil

static BNDeviceUtil *_sharedUtil;

+ (void)initialize {
    _sharedUtil = [[BNDeviceUtil alloc] init];
}

+ (instancetype)sharedUtil {
    return _sharedUtil;
}

- (id)init {
    if((self = [self init])) {
        UIScreen *screen = [UIScreen mainScreen];
        _isRetina = ([screen scale] == 2.0);
        _scale = (self.isRetina ? 2.0 : 1.0);
        _is4Inch = (_screenSize.height == 568);
        _screenSize = [screen bounds].size;
    }

    return self;
}

@end
