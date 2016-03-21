//
//  CSPMyDevicesCollectionViewController.h
//  CloudSailProtection
//
//  Created by Ice on 12/12/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabsBarBaseViewController.h"
@class DeviceTypeCategory;
@interface CSPMyDevicesCollectionViewController : TabsBarBaseViewController
@property (nonatomic, strong) DeviceTypeCategory *deviceObj;
@end
