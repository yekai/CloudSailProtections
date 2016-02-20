//
//  RoutingsTableViewCell.m
//  CloudSailProtection
//
//  Created by Ice on 1/3/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import "RoutingsTableViewCell.h"
#import "RoutingsLine.h"
#import "RoutingTableCellShowData.h"

@interface RoutingsTableViewCell()
@property (weak, nonatomic) IBOutlet RoutingTableCellShowData *routingsLine;
@property (weak, nonatomic) IBOutlet UIButton *timePointBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfRoutingDataConstraint;

@end


@implementation RoutingsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (IBAction)timePointBtnTapped:(id)sender
{
    if (self.delegate)
    {
        [self.delegate timePointBtnTapped:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRoutingTableViewCellData:(NSMutableArray *)routingData
{
    [self.routingsLine.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0)
        {
            [obj removeFromSuperview];
            self.heightOfRoutingDataConstraint.constant = 0;
        }
    }];
    self.heightOfRoutingDataConstraint.constant = (routingData.count + 1) * 20;
    [self.routingsLine setValueForRoutingTableCellData:routingData];
}

@end
