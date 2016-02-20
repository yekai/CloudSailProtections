//
//  DefaultMainObj.m
//  CloudSailProtection
//
//  Created by Ice on 12/24/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "DefaultMainObj.h"

@implementation DefaultMainObj

- (instancetype)initWithMainDict:(NSDictionary *)main
{
    if (self = [super init])
    {
        self.health = main[@"health"];
        self.currentAlarm = [main[@"currentAlarm"] stringValue];
        self.currentFault = [main[@"currentFault"] stringValue];
        
        self.alarmInfos = main[@"alarmNum"];
        self.faultInfos = main[@"faultNum"];
        
        self.beatNumbers = [main[@"beatnumber"] stringValue];
    }
    
    return self;
}
@end
