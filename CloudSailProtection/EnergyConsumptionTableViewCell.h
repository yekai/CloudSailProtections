//
//  EnergyConsumptionTableViewCell.h
//  CloudSailProtection
//
//  Created by Ice on 12/12/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PUEObj;
@interface EnergyConsumptionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *pue;
@property (weak, nonatomic) IBOutlet UILabel *totalEnergyConsumption;
@property (weak, nonatomic) IBOutlet UILabel *ITEC;

- (void)setValueFromPueObj:(PUEObj*)pue;

@end
