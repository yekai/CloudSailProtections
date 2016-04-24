//
//  MyDeviceCollectionViewCell.m
//  CloudSailProtection
//
//  Created by Ice on 12/12/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "MyDeviceCollectionViewCell.h"
#import "JSBadgeView.h"

@implementation MyDeviceCollectionViewCell


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
