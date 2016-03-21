//
//  DeviceAssets.h
//  CloudSailProtection
//
//  Created by Ice on 3/20/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceAssets : NSObject

@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *deviceCount;
@property (nonatomic, copy) NSString *assetTypeCode;
@property (nonatomic, copy) NSString *assetName;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *assetId;

- (instancetype)initWithDeviceAssetsDict:(NSDictionary*)dict;
- (NSString *)getImageName;
@end
