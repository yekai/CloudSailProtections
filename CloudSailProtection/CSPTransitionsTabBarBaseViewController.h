//
//  CSPTransitionsBaseViewController.h
//  CloudSailProtection
//
//  Created by Ice on 11/16/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPHeaderBar.h"

@interface CSPTransitionsTabBarBaseViewController : UIViewController<CSPHeaderBarDelegate>

//notice and action button bar
@property (weak, nonatomic) IBOutlet CSPHeaderBar *headerBar;

- (BOOL)getReloadStatus;
- (void)setReloadStatus:(BOOL)status;
- (void)toggleCircleChartShelterView;

@end
