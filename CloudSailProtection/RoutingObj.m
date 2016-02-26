//
//  RoutingObj.m
//  CloudSailProtection
//
//  Created by Ice on 1/3/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import "RoutingObj.h"
#import "CloudUtility.h"

@implementation RoutingObj

- (instancetype)initWithRoutingAttributes:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.name = dict[@"name"] != [NSNull null] ? dict[@"name"] : @" ";
        self.routingId = dict[@"routingId"] != [NSNull null] ? dict[@"routingId"] : @" ";
        self.routingName = dict[@"routingName"] != [NSNull null] ? dict[@"routingName"] : @" ";
        self.routingValue = dict[@"routingValue"] != [NSNull null] ? dict[@"routingValue"] : @" ";
        self.time = dict[@"time"] != [NSNull null] ?  dict[@"time"] : @" ";
    }
    
    return self;
}
@end
