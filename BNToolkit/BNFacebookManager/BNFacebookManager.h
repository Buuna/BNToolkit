//
//  BNFacebookManager.h
//  HappinessCycle
//
//  Created by Daniel Rodrigues on 17/10/13.
//  Copyright (c) 2013 Wunderman Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBNFacebookSessionStateChangedNotification @"BNFacebookSessionStateChangedNotification"

@interface BNFacebookManager : NSObject

typedef void(^BNFacebookAuthHandler)(NSString *facebookId, NSString *accessToken, NSError *error);
typedef void(^BNFacebookSuccessHandler)(BOOL success);

typedef enum {
    BNFacebookStateIdle,
    BNFacebookStateAuthenticating,
    BNFacebookStateAuthenticated
} BNFacebookState;

@property (nonatomic, readonly) NSString *userId;
@property (nonatomic, readonly) NSString *userAccessToken;
@property (nonatomic, readonly) NSString *userEmail;
@property (nonatomic, readonly) NSString *userFullName;
@property (nonatomic, readonly) NSString *userFirstName;
@property (nonatomic, readonly) NSString *userLastName;
@property (nonatomic, readonly) NSString *userGender;

+ (BNFacebookManager *)sharedManager;

- (void)authorizeFacebookWithReadPermissions:(NSArray *)permissions handler:(BNFacebookAuthHandler)handler;
- (void)reauthorizeWithPublishPermissions:(NSArray *)permissions handler:(BNFacebookSuccessHandler)handler;
- (void)presentShareLink:(NSString *)urlString name:(NSString *)name description:(NSString *)description pictureUrlString:(NSString *)pictureUrlString;
- (void)clearSession;

@end
