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
        self.name = dict[@"deviceName"] != [NSNull null] ? dict[@"deviceName"] : @" ";
        self.routingStatus = dict[@"routingStatus"] != [NSNull null] ? [dict[@"routingStatus"] integerValue] : -9;
        self.routingName = dict[@"routingName"] != [NSNull null] ? dict[@"routingName"] : @" ";
        self.routingValue = dict[@"routingValue"] != [NSNull null] ? dict[@"routingValue"] : @" ";
    }
    
    return self;
}
@end
