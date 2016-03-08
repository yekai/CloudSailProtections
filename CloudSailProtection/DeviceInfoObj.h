//
//  DeviceInfoObj.h
//  CloudSailProtection
//
//  Created by Ice on 12/25/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfoObj : NSObject

@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *alarmNum;
@property (nonatomic, copy) NSString *assetTypeCode;
@property (nonatomic, copy) NSString *url;

- (instancetype)initWithDeviceAttribute:(NSDictionary *)device;
- (NSString *)getImageName;
@end
