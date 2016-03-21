//
//  DeviceAssets.m
//  CloudSailProtection
//
//  Created by Ice on 3/20/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import "DeviceAssets.h"

@implementation DeviceAssets


- (instancetype)initWithDeviceAssetsDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.count = dict[@"alarmCount"];
        self.deviceCount = dict[@"deviceCount"];
        self.assetTypeCode = dict[@"assetTypeCode"];
        self.assetName = dict[@"assetTypeName"];
        self.url = dict[@"url"];
        self.assetId = dict[@"assetTypeId"];
    }
    
    return self;
}

- (NSString *)getImageName
{
    NSString *imageName = nil;
    if ([self.assetName hasPrefix:@"配电柜"])
    {
        imageName = @"peiDianGui";
    }
    else if ([self.assetName hasPrefix:@"UPS"] || [self.assetName containsString:@"路由器"])
    {
        imageName = @"UPS";
    }
    else if ([self.assetName hasPrefix:@"空调"])
    {
        imageName = @"kongTiao";
    }
    else if ([self.assetName hasPrefix:@"温湿度"])
    {
        imageName = @"wenShiDu";
    }
    else if ([self.assetName hasPrefix:@"漏水"])
    {
        imageName = @"louShui";
    }
    else if ([self.assetName hasPrefix:@"安防"])
    {
        imageName = @"louShui";
    }
    else if ([self.assetName hasPrefix:@"电量仪"])
    {
        imageName = @"dianLiangYi";
    }
    else if ([self.assetName hasPrefix:@"蓄电池"])
    {
        imageName = @"xuDianChi";
    }
    else if ([self.assetName hasPrefix:@"防雷"])
    {
        imageName = @"fangLei";
    }
    else if ([self.assetName hasPrefix:@"视频"])
    {
        imageName = @"shiPin";
    }
    else if ([self.assetName hasPrefix:@"新风机"])
    {
        imageName = @"xinFengJi";
    }
    else if ([self.assetName hasPrefix:@"门禁"])
    {
        imageName = @"menJin";
    }
    
    return imageName;
}
@end
