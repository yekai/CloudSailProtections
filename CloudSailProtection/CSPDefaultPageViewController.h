//
//  CSPMyConcernViewController.h
//  CloudSailProtection
//
//  Created by Ice on 11/14/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPTransitionsTabBarBaseViewController.h"
#import "PNChart.h"

@interface CSPDefaultPageViewController : CSPTransitionsTabBarBaseViewController<PNChartDelegate>
//the content view for three parts of the default dash board
@property (strong, nonatomic) IBOutlet UIView *contentView;
//reload default dash page three parts data
- (void)reloadMainAttributes;

- (NSArray *)getAlarmsInfo;
- (NSArray *)tabBarStatesForCurrentApps;
@end
