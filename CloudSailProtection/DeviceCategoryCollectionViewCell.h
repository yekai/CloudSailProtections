//
//  DeviceCategoryCollectionViewCell.h
//  CloudSailProtection
//
//  Created by Ice on 3/20/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceCategoryCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel     *categoryName;

- (void)configureCellWithBadgeNumber:(NSString *)badge;
- (void)hideBadge;
@end
