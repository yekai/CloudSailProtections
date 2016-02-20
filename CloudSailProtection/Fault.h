//
//  Fault.h
//  CloudSailProtection
//
//  Created by Ice on 12/24/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fault : NSObject

@property (nonatomic, copy) NSString *faultContent;
@property (nonatomic, copy) NSString *faultType;
@property (nonatomic, copy) NSString *faultTypeName;
@property (nonatomic, copy) NSString *faultId;
@property (nonatomic, copy) NSString *faultStatus;
@property (nonatomic, copy) NSString *faultStatusName;
@property (nonatomic, copy) NSString *faultDeclarer;
@property (nonatomic, copy) NSString *linkPhone;
@property (nonatomic, copy) NSString *contract;
@property (nonatomic, copy) NSString *assetInfo;
@property (nonatomic, copy) NSString *locationInfo;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *customerName;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *handle;
@property (nonatomic, copy) NSString *handleTime;
@property (nonatomic, copy) NSString *handleTimeView;
@property (nonatomic, copy) NSString *createTimeView;
@property (nonatomic, copy) NSString *handlerInfo;
@property (nonatomic, copy) NSString *confirm;
@property (nonatomic, copy) NSString *confirmInfo;
@property (nonatomic, copy) NSString *confirmTime;
@property (nonatomic, copy) NSString *confirmTimeView;

- (instancetype)initWithFaultAttributes:(NSDictionary *)fault;

@end
