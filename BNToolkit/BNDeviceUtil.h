//
//  BNDeviceUtil.h
//
//
//  Created by Daniel Rodrigues on 27/06/13.
//  Copyright (c) 2013 Buuna Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_RETINA ([BNDeviceUtil sharedInstance].isRetina)
#define IS_IPHONE5 ([BNDeviceUtil sharedInstance].is4Inch)

@interface BNDeviceUtil : NSObject

+ (instancetype)sharedUtil;

@property(nonatomic, readonly) BOOL isRetina;
@property(nonatomic, readonly) CGFloat scale;
@property(nonatomic, readonly) BOOL is4Inch;
@property(nonatomic, readonly) CGSize screenSize;

@end
