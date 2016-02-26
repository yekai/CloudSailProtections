//
//  BreakdownsTableViewCell.m
//  CloudSailProtection
//
//  Created by Ice on 12/2/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "BreakdownsTableViewCell.h"
#import "Fault.h"
#import "CloudUtility.h"

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
    self.date.text = [CloudUtility isNullString: fault.createTimeView];
    self.applyPerson.text = [CloudUtility isNullString: fault.faultDeclarer];
    self.state.text = [CloudUtility isNullString: fault.faultStatusName];
    
    self.type.text = [CloudUtility isNullString: fault.assetInfo];
    
    self.position.text = [CloudUtility isNullString: fault.locationInfo];
    self.resource.text = [CloudUtility isNullString: fault.linkPhone];
    self.content.text = [CloudUtility isNullString: fault.faultContent];
}


@end
