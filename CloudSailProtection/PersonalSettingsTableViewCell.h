//
//  PersonalSettingsTableViewCell.h
//  CloudSailProtection
//
//  Created by Ice on 12/20/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalSettingsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

- (void)setValueForPersonalSettingsCell:(NSDictionary *)dict;
@end
