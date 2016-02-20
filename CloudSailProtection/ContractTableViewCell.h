//
//  ContractTableViewCell.h
//  CloudSailProtection
//
//  Created by Ice on 12/12/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Agreements;
@interface ContractTableViewCell : UITableViewCell

- (void)setValueFromAgreements:(Agreements *)agreement;

@end
