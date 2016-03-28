//
//  DeviceCategoryCollectionViewCell.m
//  CloudSailProtection
//
//  Created by Ice on 3/20/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import "DeviceCategoryCollectionViewCell.h"
#import "JSBadgeView.h"
@implementation DeviceCategoryCollectionViewCell

- (void)configureCellWithBadgeNumber:(NSString *)badge
{
    JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:self.image alignment:JSBadgeViewAlignmentTopRightInside];
    [self.image addSubview:badgeView];
    badgeView.badgeText = badge;
    badgeView.tag = 0xAAA;
}

- (void)hideBadge
{
    JSBadgeView *badgeView = [self.image viewWithTag:0xAAA];
    [badgeView removeFromSuperview];
}
@end
