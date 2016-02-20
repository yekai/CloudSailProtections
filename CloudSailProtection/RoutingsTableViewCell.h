//
//  RoutingsTableViewCell.h
//  CloudSailProtection
//
//  Created by Ice on 1/3/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoutingsTableViewCell;

@protocol RoutingsTableViewCellDelegate <NSObject>

- (void)timePointBtnTapped:(RoutingsTableViewCell *)cell;

@end


@interface RoutingsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, weak) id<RoutingsTableViewCellDelegate> delegate;

- (void)setRoutingTableViewCellData:(NSMutableArray *)routingData;
@end
