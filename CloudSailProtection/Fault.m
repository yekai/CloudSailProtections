//
//  Fault.m
//  CloudSailProtection
//
//  Created by Ice on 12/24/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "Fault.h"

@implementation Fault

- (instancetype)initWithFaultAttributes:(NSDictionary *)fault
{
    if (self = [super init])
    {
        self.faultContent = fault[@"content"];
        self.faultType = fault[@"type"];
        self.faultTypeName = fault[@"typeName"];
        self.faultId = fault[@"id"];
        self.faultStatus = fault[@"status"];
        self.faultStatusName = fault[@"statusName"];
        self.faultDeclarer = fault[@"declarer"];
        self.linkPhone = fault[@"linkphone"];
        self.contract = fault[@"contract"];
        self.assetInfo = fault[@"assetInfo"];
        self.locationInfo = fault[@"locationInfo"];
        self.customerId = fault[@"customerid"];
        self.customerName = fault[@"customerName"];
        self.createTime = fault[@"createTime"];
        self.handle = fault[@"handler"];
        self.handleTime = fault[@"handlerTime"];
        self.handleTimeView = fault[@"handlerTimeView"];
        self.createTimeView = fault[@"createTimeView"];
        self.handlerInfo = fault[@"handlerInfo"];
        self.confirm = fault[@"confirmer"];
        self.confirmInfo = fault[@"confirmInfo"];
        self.confirmTime = fault[@"confirmTime"];
        self.confirmTimeView = fault[@"confirmTimeView"];
    }
    
    return self;
}
@end
