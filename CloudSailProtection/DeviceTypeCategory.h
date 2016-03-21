//
//  DeviceTypeCategory.h
//  CloudSailProtection
//
//  Created by Ice on 3/20/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceTypeCategory : NSObject

@property (nonatomic, copy) NSString *alarmCount;
@property (nonatomic, copy) NSString *typeId;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *typeCount;
@property (nonatomic, copy) NSString *assetTypeCode;

- (instancetype)initWithDict:(NSDictionary *)deviceTypeCategoryDict;
@end
