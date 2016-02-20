//
//  BreakdownsTableViewCell.h
//  CloudSailProtection
//
//  Created by Ice on 12/2/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Fault;
@interface BreakdownsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *resource;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *applyPerson;


- (void)setValueFromFault:(Fault *)fault;

@end
