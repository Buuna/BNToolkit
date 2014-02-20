//
//  BNDeviceUtil.h
//
//  Created by Daniel Rodrigues on 27/06/13.
//  Copyright (c) 2013 Buuna Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_RETINA ([BNDeviceUtil isRetina])
#define IS_IPHONE5 ([BNDeviceUtil is4Inch])

@interface BNDeviceUtil : NSObject

+(BOOL) isRetina;
+(CGFloat) scale;
+(BOOL) is4Inch;
+(CGSize) screenSize;

@end
