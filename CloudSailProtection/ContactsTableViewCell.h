//
//  ContactsTableViewCell.h
//  CloudSailProtection
//
//  Created by Ice on 12/1/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Communicator;
@interface ContactsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *provider;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumber;

- (void)setValueFromContacts:(Communicator *)contact;
@end
