//
//  UserSession.m
//  CitiesTestTask
//
//  Created by Daniil Novoselov on 23.03.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

#import "UserSession.h"

@implementation UserSession
static NSString *const kAccessToken = @"sessionAccessToken";
static NSString *const kUserID = @"userID";

- (instancetype)init {
    return [[self class] currentSession];
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken];
        _userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserID];
    }
    return self;
}

+ (instancetype)currentSession {
    static UserSession *sharedSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSession = [[UserSession alloc] initPrivate];
        
    });
    return sharedSession;

}


- (BOOL)isAuthorized {
    return _accessToken ? YES : NO;
}

- (void)logout {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)setAccessToken:(NSString *)accessToken {
    if ([_accessToken isEqualToString:accessToken]) {
        return;
    }
    _accessToken = accessToken;
    [[NSUserDefaults standardUserDefaults] setObject:_accessToken forKey:kAccessToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setUserID:(NSString *)userID {
    if ([_userID isEqualToString:userID]) {
        return;
    }
    _userID = userID;
    [[NSUserDefaults standardUserDefaults] setObject:_userID forKey:kUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

/*
 -(void)saveAccessToken:(NSString *)token andUserID:(NSString *)userID {
 if (token) {
 [[NSUserDefaults standardUserDefaults] setObject:token forKey:kAccessToken];
 }
 if (userID) {
 [[NSUserDefaults standardUserDefaults] setObject:userID forKey:kUserID];
 }
 [[NSUserDefaults standardUserDefaults] synchronize];
 }
*/
