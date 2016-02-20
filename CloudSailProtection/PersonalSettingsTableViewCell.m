//
//  PersonalSettingsTableViewCell.m
//  CloudSailProtection
//
//  Created by Ice on 12/20/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "PersonalSettingsTableViewCell.h"

@implementation PersonalSettingsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueForPersonalSettingsCell:(NSDictionary *)dict
{
    self.nameLbl.text = [dict allKeys][0];
    self.contentLbl.text = [dict allValues][0];
}
@end
