//
//  BreakdownsTableViewCell.m
//  CloudSailProtection
//
//  Created by Ice on 12/2/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "BreakdownsTableViewCell.h"
#import "Fault.h"

@implementation BreakdownsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueFromFault:(Fault *)fault
{
    self.date.text = fault.createTimeView;
    self.applyPerson.text = fault.faultDeclarer;
    self.state.text = fault.faultStatusName;
    
    self.type.text = fault.assetInfo;
    
    self.position.text = fault.locationInfo;
    self.resource.text = fault.linkPhone;
    self.content.text = fault.faultContent;
}

@end
