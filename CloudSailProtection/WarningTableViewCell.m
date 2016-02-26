//
//  WarningTableViewCell.m
//  CloudSailProtection
//
//  Created by Ice on 12/3/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "WarningTableViewCell.h"
#import "Alarm.h"
#import "CloudUtility.h"

@implementation WarningTableViewCell


- (void)setValueForWarningTableCellWithAlarm:(Alarm *)alarm
{
    self.date.text = [CloudUtility isNullString: alarm.alarmTime];
    self.grade.text = [CloudUtility isNullString: alarm.alarmLevelName];
    self.state.text = [CloudUtility isNullString: alarm.alarmStatusName];
    self.type.text = [CloudUtility isNullString: alarm.assetTypeName];
    self.position.text = [CloudUtility isNullString: alarm.locationName];
    self.resource.text = [CloudUtility isNullString: alarm.assetName];
    self.content.text = [CloudUtility isNullString: alarm.alarmDesc];
}


@end
