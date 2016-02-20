//
//  Notice.m
//  CloudSailProtection
//
//  Created by Ice on 12/21/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "Notice.h"

@implementation Notice

- (instancetype)initWithAttribute:(NSDictionary *)notice
{
    if (self =[super init])
    {
        self.noticeId = notice[@"id"];
        self.content = notice[@"content"];
        self.recordtimeString = notice[@"recordtimeString"];
    }
    
    return self;
}

@end
