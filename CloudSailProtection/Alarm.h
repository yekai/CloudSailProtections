//
//  Alarm.h
//  CloudSailProtection
//
//  Created by Ice on 12/22/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alarm : NSObject

@property (nonatomic, copy) NSString *alarmId;
@property (nonatomic, copy) NSString *alarmTime;
@property (nonatomic, copy) NSString *alarmDesc;
@property (nonatomic, copy) NSString *alarmStatus;
@property (nonatomic, copy) NSString *alarmStatusName;

@property (nonatomic, copy) NSString *assetId;
@property (nonatomic, copy) NSString *assetName;
@property (nonatomic, copy) NSString *assetTypeId;
@property (nonatomic, copy) NSString *assetTypeName;
@property (nonatomic, copy) NSString *assetTypeCode;

@property (nonatomic, copy) NSString *locationId;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, copy) NSString *locationCode;

@property (nonatomic, copy) NSString *alarmLevel;
@property (nonatomic, copy) NSString *alarmLevelName;

@property (nonatomic, copy) NSString *subSystemId;
@property (nonatomic, copy) NSString *handleStatus;
@property (nonatomic, copy) NSString *handleTime;
@property (nonatomic, copy) NSString *handlePerson;
@property (nonatomic, copy) NSString *handleInfo;

@property (nonatomic, copy) NSString *confirmer;
@property (nonatomic, copy) NSString *confirmStatus;
@property (nonatomic, copy) NSString *confirmTime;
@property (nonatomic, copy) NSString *pid;


- (instancetype)initWithAlarmAttributes:(NSDictionary *)alarm;
@end
