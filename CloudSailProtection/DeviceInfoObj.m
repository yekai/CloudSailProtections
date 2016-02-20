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
        self.deviceName = device[@"assetName"];
        self.deviceId = device[@"assetid"];
        self.alarmNum = device[@"count"];
    }
    
    return self;
}

- (NSString *)getImageName
{
    NSString *imageName = nil;
    if ([self.deviceName hasPrefix:@"配电柜"])
    {
        imageName = @"peiDianGui";
    }
    else if ([self.deviceName hasPrefix:@"UPS"] || [self.deviceName containsString:@"路由器"])
    {
        imageName = @"UPS";
    }
    else if ([self.deviceName hasPrefix:@"空调"])
    {
        imageName = @"kongTiao";
    }
    else if ([self.deviceName hasPrefix:@"温湿度"])
    {
        imageName = @"wenShiDu";
    }
    else if ([self.deviceName hasPrefix:@"漏水"])
    {
        imageName = @"louShui";
    }
    else if ([self.deviceName hasPrefix:@"安防"])
    {
        imageName = @"louShui";
    }
    else if ([self.deviceName hasPrefix:@"电量仪"])
    {
        imageName = @"dianLiangYi";
    }
    else if ([self.deviceName hasPrefix:@"蓄电池"])
    {
        imageName = @"xuDianChi";
    }
    else if ([self.deviceName hasPrefix:@"防雷"])
    {
        imageName = @"fangLei";
    }
    else if ([self.deviceName hasPrefix:@"视频"])
    {
        imageName = @"shiPin";
    }
    else if ([self.deviceName hasPrefix:@"新风机"])
    {
        imageName = @"xinFengJi";
    }
    else if ([self.deviceName hasPrefix:@"门禁"])
    {
        imageName = @"menJin";
    }
    
    return imageName;
}
@end
