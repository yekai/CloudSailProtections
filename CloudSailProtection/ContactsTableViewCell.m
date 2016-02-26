//
//  ContactsTableViewCell.m
//  CloudSailProtection
//
//  Created by Ice on 12/1/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "ContactsTableViewCell.h"
#import "Communicator.h"
#import "CloudUtility.h"

@implementation ContactsTableViewCell

-(void)setValueFromContacts:(Communicator *)contact
{
    self.provider.text = [CloudUtility isNullString: contact.name];
    [self.phoneNumber setTitle:[CloudUtility isNullString: contact.phone] forState:UIControlStateNormal];
    [self.phoneNumber setTitle:[CloudUtility isNullString: contact.phone] forState:UIControlStateHighlighted];
}




@end
