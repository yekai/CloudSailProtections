//
//  PUEObj.m
//  CloudSailProtection
//
//  Created by Ice on 12/25/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "PUEObj.h"

@implementation PUEObj


- (instancetype)initWithPUEAttribute:(NSDictionary *)pue
{
    if (self = [super init])
    {
        self.type = pue[@"type"];
        self.name = pue[@"name"];
        self.value = pue[@"value"];
        self.time = pue[@"time"];
    }
    
    return self;
}
@end
