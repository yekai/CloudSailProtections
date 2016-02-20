//
//  EnergyConsumptionTableViewCell.m
//  CloudSailProtection
//
//  Created by Ice on 12/12/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "EnergyConsumptionTableViewCell.h"
#import "PUEObj.h"

@implementation EnergyConsumptionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueFromPueObj:(PUEObj *)pue
{
    self.date.text = [pue.time substringToIndex:10];
    self.pue.text = pue.value;
    self.totalEnergyConsumption.text = pue.value;
    self.ITEC.text = pue.value;
}

@end
