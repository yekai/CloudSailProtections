//
//  DeviceTypeCategory.m
//  CloudSailProtection
//
//  Created by Ice on 3/20/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import "DeviceTypeCategory.h"

@implementation DeviceTypeCategory

- (instancetype)initWithDict:(NSDictionary *)deviceTypeCategoryDict
{
    if (self = [super init])
    {
        self.alarmCount = deviceTypeCategoryDict[@"alarmCount"];
        self.typeCount = deviceTypeCategoryDict[@"deviceCount"];
        self.typeName = deviceTypeCategoryDict[@"assetTypeName"];
        self.url = deviceTypeCategoryDict[@"url"];
        self.typeId = deviceTypeCategoryDict[@"assetTypeId"];
        self.assetTypeCode = deviceTypeCategoryDict[@"assetTypeCode"];
    }
    
    return self;
}
@end
