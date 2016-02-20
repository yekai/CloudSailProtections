//
//  Communicator.m
//  CloudSailProtection
//
//  Created by Ice on 12/25/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "Communicator.h"

@implementation Communicator


- (instancetype)initWithCommunicatorAttribute:(NSDictionary *)comm
{
    if (self = [super init])
    {
        self.name = comm[@"name"];
        self.phone = comm[@"phonenum"];
    }
    
    return self;
}
@end
