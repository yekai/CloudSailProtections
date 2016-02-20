//
//  NoticesTableViewCell.h
//  CloudSailProtection
//
//  Created by Ice on 12/13/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Notice;
@interface NoticesTableViewCell : UITableViewCell

- (void)setValueFromNotice:(Notice *)notice withIndex:(NSInteger)index;
@end
