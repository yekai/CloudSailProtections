//
//  WarningTableViewCell.m
//  CloudSailProtection
//
//  Created by Ice on 12/3/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "WarningTableViewCell.h"
#import "Alarm.h"

@implementation WarningTableViewCell


- (void)setValueForWarningTableCellWithAlarm:(Alarm *)alarm
{
    self.date.text = alarm.alarmTime;
    self.grade.text = alarm.alarmLevelName;
    self.state.text = alarm.alarmStatusName;
    self.type.text = alarm.assetTypeName;
    self.position.text = alarm.locationName;
    self.resource.text = alarm.assetName;
    self.content.text = alarm.alarmDesc;
}

- (void)awakeFromNib {
    // Initialization code
}

- (NSString *)getGradeFromAlarmLevel:(NSString *)level
{
    return [NSString stringWithFormat:@"%@级",level];
}

- (NSString *)getAlarmStates
{
    NSInteger random = (NSInteger) (arc4random() * 13) % 2;
    
    if (random == 0)
    {
        return @"未解除";
    }
    
    
    return @"已解除";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
