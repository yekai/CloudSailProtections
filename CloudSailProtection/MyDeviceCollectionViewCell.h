//
//  MyDeviceCollectionViewCell.h
//  CloudSailProtection
//
//  Created by Ice on 12/12/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDeviceCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel     *deviceName;

- (void)configureCellWithBadgeNumber:(NSString *)badge;
- (void)hideBadge;
@end
