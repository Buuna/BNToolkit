//
//  BNFacebookManager.m
//
//  Created by Daniel Rodrigues on 17/10/13.
//  Copyright (c) 2013 Buuna Pty Ltd. All rights reserved.
//

#import "BNFacebookManager.h"

#import "Facebook.h"

static BNFacebookManager *_sharedManager;

@interface BNFacebookManager () {
    NSConditionLock *_facebookLock;
}

@end

@implementation BNFacebookManager

+ (void)initialize {
    _sharedManager = [[self alloc] init];
}

+ (BNFacebookManager *)sharedManager {
    return _sharedManager;
}

- (id)init {
    if((self = [super init])) {
        _facebookLock = [[NSConditionLock alloc] initWithCondition:BNFacebookStateIdle];
    }
    return self;
}

- (void)authorizeFacebookWithReadPermissions:(NSArray *)permissions handler:(BNFacebookAuthHandler)handler {
    [_facebookLock lock];
    [_facebookLock unlockWithCondition:BNFacebookStateAuthenticating];
    
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState state,
                                                      NSError *error)
     {
         id sessionStateChangeHandler = ^(BOOL success) {
             if(success) {
                 [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
                  {
                      if(!error) {
                          _userId = [user objectForKey:@"id"];
                          _userEmail = [user objectForKey:@"email"];
                          _userFullName = [user objectForKey:@"name"];
                          _userFirstName = [user objectForKey:@"first_name"];
                          _userLastName = [user objectForKey:@"last_name"];
                          _userGender = [user objectForKey:@"gender"];
                          NSString *facebookAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
                          handler(_userId, facebookAccessToken, nil);
                      } else {
                          handler(nil, nil, error);
                      }
                  }];
             } else {
                 handler(nil, nil, error);
             }
         };
         
         [self sessionStateChanged:session state:state error:error handler:sessionStateChangeHandler];
     }];
}

- (void)reauthorizeWithPublishPermissions:(NSArray *)permissions handler:(BNFacebookSuccessHandler)handler {
    [[FBSession activeSession] requestNewPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error)
    {
        if(!error) {
            NSLog(@"successfully reauthorised with publish permissions");
            
            handler(YES);
        } else {
            NSLog(@"failed to reauthorise with permissions with error: %@", error);
            
            handler(NO);
        }
    }];
}

- (void)presentShareLink:(NSString *)urlString name:(NSString *)name description:(NSString *)description pictureUrlString:(NSString *)pictureUrlString
{
    [FBDialogs presentShareDialogWithLink:[NSURL URLWithString:urlString]
                                     name:name
                                  caption:@"Caption Placeholder"
                              description:description
                                  picture:[NSURL URLWithString:pictureUrlString]
                              clientState:nil
                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error)
     {
         if(error) {
             NSLog(@"failed to present share link with error: %@", error.description);
         } else {
             NSLog(@"successfully presented share link");
         }
     }];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
                    handler:(void(^)(BOOL success))handler
{
    [_facebookLock lock];
    switch (state) {
        case FBSessionStateOpen:
            if(!error) {
                if(_facebookLock.condition == BNFacebookStateAuthenticating) {
                    NSLog(@"FBSessionStateOpen authenticated successfully");
                    handler(YES);
                } else {
                    NSLog(@"WARNING: FBSessionStateOpen when already authenticated?");
                }
                [_facebookLock unlockWithCondition:BNFacebookStateAuthenticated];
            } else {
                [_facebookLock unlockWithCondition:BNFacebookStateIdle];
            }
            break;
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            [_facebookLock unlockWithCondition:BNFacebookStateIdle];
            handler(NO);
            break;
        case FBSessionStateClosed:
            if(_facebookLock.condition == BNFacebookStateAuthenticated) {
                NSLog(@"FBSessionStateClosed after authenticated");
                [_facebookLock unlockWithCondition:BNFacebookStateIdle];
            } else {
                NSLog(@"FBSessionStateClosed before authenticating(!)");
                [_facebookLock unlock];
            }
            break;
        default:
            [_facebookLock unlock];
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kBNFacebookSessionStateChangedNotification
     object:session];
}

- (void)clearSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (NSString *)userAccessToken {
    return [FBSession activeSession].accessTokenData.accessToken;
}

@end
