//
//  DeviceInfoObj.h
//  CloudSailProtection
//
//  Created by Ice on 12/25/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfoObj : NSObject

@property (nonatomic, copy) NSString *assetName;
@property (nonatomic, copy) NSString *assetTypeName;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, copy) NSString *alarmCount;
@property (nonatomic, copy) NSString *assetId;

- (instancetype)initWithDeviceAttribute:(NSDictionary *)device;
@end
