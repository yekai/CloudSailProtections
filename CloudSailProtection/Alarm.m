//
//  Alarm.m
//  CloudSailProtection
//
//  Created by Ice on 12/22/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "Alarm.h"

@implementation Alarm

- (instancetype)initWithAlarmAttributes:(NSDictionary *)alarm
{
    if (self = [super init])
    {
        self.alarmId = alarm[@"alarmid"];
        self.alarmTime = alarm[@"alarmTime"];
        self.alarmDesc = alarm[@"alarmDesc"];
        self.alarmStatus = alarm[@"alarmStatus"];
        self.alarmStatusName = alarm[@"alarmStatusName"];

        self.assetId = alarm[@"assetid"];
        self.assetName = alarm[@"assetName"];
        self.assetTypeId = alarm[@"assetTypeId"];
        self.assetTypeName = alarm[@"assetTypeName"];
        self.assetTypeCode = alarm[@"assetTypeCode"];
        
        self.locationId = alarm[@"locationid"];
        self.locationName = alarm[@"locationName"];
        self.locationCode = alarm[@"locationCode"];
        
        self.alarmLevel = alarm[@"alarmLevel"];
        self.alarmLevelName = alarm[@"alarmLevelName"];
        
        self.subSystemId = alarm[@"subSystemId"];
        self.handleStatus = alarm[@"handleStatus"];
        self.handleTime = alarm[@"handleTime"];
        self.handlePerson = alarm[@"handlePerson"];
        self.handleInfo = alarm[@"handleInfo"];
        self.confirmer = alarm[@"confirmer"];
        self.confirmStatus = alarm[@"confirmStatus"];
        self.confirmTime = alarm[@"confirmTime"];
        self.pid = alarm[@"pid"];
    }
    
    return self;
}
@end
