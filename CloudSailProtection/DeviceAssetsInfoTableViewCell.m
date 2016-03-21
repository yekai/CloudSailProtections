//
//  DeviceAssetsInfoTableViewCell.m
//  CloudSailProtection
//
//  Created by Ice on 3/21/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import "DeviceAssetsInfoTableViewCell.h"
#import "DeviceInfoObj.h"
@implementation DeviceAssetsInfoTableViewCell

- (void)configureWithDeviceInfoObj:(DeviceInfoObj *)obj
{
    self.deviceLocation.text = obj.locationName;
    self.assetName.text = obj.assetName;
    self.alarmCount.text = obj.alarmCount;
    self.deviceType.text = obj.assetTypeName;
}

@end
