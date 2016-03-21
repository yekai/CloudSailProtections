//
//  DeviceAssetsInfoTableViewCell.h
//  CloudSailProtection
//
//  Created by Ice on 3/21/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeviceInfoObj;
@interface DeviceAssetsInfoTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *assetName;
@property (nonatomic, weak) IBOutlet UILabel *alarmCount;
@property (nonatomic, weak) IBOutlet UILabel *deviceType;
@property (nonatomic, weak) IBOutlet UILabel *deviceLocation;

- (void)configureWithDeviceInfoObj:(DeviceInfoObj *)obj;
@end
