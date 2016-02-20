//
//  SessionManager.h
//  CloudSailProtection
//
//  Created by Ice on 11/16/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;
@interface SessionManager : NSObject

@property (nonatomic, strong, readonly) User *user;
@property (nonatomic, copy, readonly) NSString *token;

+ (instancetype)sharedManager;

- (void)configWithLoginInfo:(NSDictionary *)info andPassword:(NSString *)password;

- (BOOL)isLoggedIn;

- (void)logout;
@end
