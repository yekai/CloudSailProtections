//
//  ContractTableViewCell.m
//  CloudSailProtection
//
//  Created by Ice on 12/12/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "ContractTableViewCell.h"
#import "Agreements.h"

@interface ContractTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *corporationName;
@property (weak, nonatomic) IBOutlet UILabel *dateRange;
@property (weak, nonatomic) IBOutlet UILabel *serviceHours;
@property (weak, nonatomic) IBOutlet UILabel *spotFrequency;
@property (weak, nonatomic) IBOutlet UILabel *remoteFrequency;
@property (weak, nonatomic) IBOutlet UILabel *respondTime;
@property (weak, nonatomic) IBOutlet UILabel *requiredReachSpotTime;
@property (weak, nonatomic) IBOutlet UILabel *requiredResolveTime;

@end

@implementation ContractTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueFromAgreements:(Agreements *)agreement
{
    
    self.corporationName.text = agreement.name;
    self.dateRange.text = [NSString stringWithFormat:@"%@到%@",agreement.startTimeString, agreement.endTimeString];
    self.serviceHours.text = [NSString stringWithFormat:@"%@小时", agreement.serviceTime];
    self.spotFrequency.text = [NSString stringWithFormat:@"%@次/年", agreement.scenerate];
    self.remoteFrequency.text = [NSString stringWithFormat:@"%@次/天", agreement.remoteRate];
    self.respondTime.text = [NSString stringWithFormat:@"%@小时", agreement.response];
    self.requiredReachSpotTime.text = [NSString stringWithFormat:@"%@小时", agreement.reachScene];
    self.requiredResolveTime.text = [NSString stringWithFormat:@"%@小时", agreement.solve];
}

@end
