//
//  MenuTableViewCell.h
//  CloudSailProtection
//
//  Created by Ice on 11/30/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *menuImage;
@property (nonatomic, weak) IBOutlet UIImageView *extendImage;
@property (nonatomic, weak) IBOutlet UILabel     *textTitle;

@end
