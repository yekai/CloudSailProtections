//
//  SessionManager.m
//  CloudSailProtection
//
//  Created by Ice on 11/16/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "SessionManager.h"
#import "User.h"

@interface SessionManager ()

@property (nonatomic, strong) User *user;
@property (nonatomic, copy) NSString *token;

@end


@implementation SessionManager

+ (instancetype)sharedManager
{
    static SessionManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[SessionManager alloc] init];
    });
    
    return _sharedManager;
}

- (void)configWithLoginInfo:(NSDictionary *)info andPassword:(NSString *)password
{
    self.token = info[@"token"];
    self.user = [[User alloc]initWithAttributes:info[@"user"] andPassword:password];
}

- (BOOL)isLoggedIn
{
    return self.token != nil;
}

- (void)logout
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in _tmpArray)
    {
        [cookieJar deleteCookie:obj];
    }
    
    self.token = nil;
    self.user = nil;
}

@end
