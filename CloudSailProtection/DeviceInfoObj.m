//
//  DeviceInfoObj.m
//  CloudSailProtection
//
//  Created by Ice on 12/25/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "DeviceInfoObj.h"

@implementation DeviceInfoObj

- (instancetype)initWithDeviceAttribute:(NSDictionary *)device
{
    if (self = [super init])
    {
        self.assetName = device[@"assetName"];
        self.assetTypeName = device[@"assetTypeName"];
        self.locationName = device[@"locationName"];
        self.alarmCount = device[@"alarmCount"];
        self.assetId = device[@"assetId"];
    }
    
    return self;
}

@end
