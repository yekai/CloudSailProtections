//
//  ContactsTableViewCell.m
//  CloudSailProtection
//
//  Created by Ice on 12/1/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "ContactsTableViewCell.h"
#import "Communicator.h"
@implementation ContactsTableViewCell

-(void)setValueFromContacts:(Communicator *)contact
{
    self.provider.text = contact.name;
    [self.phoneNumber setTitle:contact.phone forState:UIControlStateNormal];
    [self.phoneNumber setTitle:contact.phone forState:UIControlStateHighlighted];
}




@end
