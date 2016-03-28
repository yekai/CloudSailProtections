//
//  EnergyConsumptionTableViewCell.m
//  CloudSailProtection
//
//  Created by Ice on 12/12/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "EnergyConsumptionTableViewCell.h"
#import "PUEObj.h"
#import "CloudUtility.h"

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
    self.date.text = [CloudUtility isNullString: pue.time].length > 10 ? [pue.time substringToIndex:10] : pue.time;
    self.pue.text = [CloudUtility isNullString: pue.pue];
    self.totalEnergyConsumption.text = [CloudUtility isNullString: pue.totalEnergy];
    self.ITEC.text = [CloudUtility isNullString: pue.itEnergy];
}

@end
