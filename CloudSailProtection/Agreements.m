//
//  Agreements.m
//  CloudSailProtection
//
//  Created by Ice on 12/25/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "Agreements.h"

@implementation Agreements

- (instancetype)initWithAgreementsAttribute:(NSDictionary *)agreement
{
    if (self = [super init])
    {
        self.name = agreement[@"name"];
        self.serviceTime = agreement[@"servicetime"];
        self.scenerate = agreement[@"scenerate"];
        self.phoneRate = agreement[@"phonerate"];
        self.remoteRate = agreement[@"remoterate"];
        self.response = agreement[@"response"];
        self.reachScene = agreement[@"reachscene"];
        self.solve = agreement[@"solve"];
        self.startTimeString = agreement[@"starttimeString"];
        self.endTimeString = agreement[@"endtimeString"];
    }
    
    return self;
}
@end
