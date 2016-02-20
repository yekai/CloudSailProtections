//
//  WarningTableViewCell.h
//  CloudSailProtection
//
//  Created by Ice on 12/3/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Alarm;
@interface WarningTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *grade;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *resource;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *date;

- (void)setValueForWarningTableCellWithAlarm:(Alarm *)alarm;

@end
