//
//  UserSession.h
//  CitiesTestTask
//
//  Created by Daniil Novoselov on 23.03.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSession : NSObject

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *userID;

+ (instancetype)currentSession;

- (BOOL)isAuthorized;
- (void)logout;


@end
