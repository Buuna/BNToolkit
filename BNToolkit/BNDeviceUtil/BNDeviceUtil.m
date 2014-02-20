//
//  BNDeviceUtil.m
//
//  Created by Daniel Rodrigues on 27/06/13.
//  Copyright (c) 2013 Buuna Pty Ltd. All rights reserved.
//

#import "BNDeviceUtil.h"

@implementation BNDeviceUtil

static UIScreen * screen;
static BOOL isRetina;
static CGFloat scale;
static BOOL is4inch;
static CGSize screensize;

+ (void)initialize {
    screen = [UIScreen mainScreen];
    isRetina =  ([screen scale] == 2.0);
    scale = (isRetina ? 2.0 : 1.0);
    screensize = [screen bounds].size;
    is4inch = (screensize.height == 568);
}

+ (BOOL)isRetina {
    return isRetina;
}

+ (CGFloat)scale {
    return scale;
}

+ (BOOL)is4Inch {
    return is4inch;
}

+ (CGSize)screenSize {
    return screensize;
}

@end
