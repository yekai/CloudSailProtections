//
//  Routing.m
//  CloudSailProtection
//
//  Created by Ice on 12/25/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "Routing.h"

@implementation Routing

- (instancetype)initWithRoutingAttributes:(NSDictionary *)routing
{
    if (self = [super init])
    {
        self.name = routing[@"name"];
        self.routingid = routing[@"routingid"];
        self.routingname = routing[@"routingname"];
        self.routingvalue = routing[@"routingvalue"];
        self.time = routing[@"time"];
    }
    
    return self;
}
@end
