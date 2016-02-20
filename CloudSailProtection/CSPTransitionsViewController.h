//
//  CSPTransitionsViewController.h
//  CloudSailProtection
//
//  Created by Ice on 11/13/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "AHTabBarController.h"
#import "CSPDefaultPageViewController.h"

/**
 *@brief the tab bar page control for default dashboard
 *
 *
 */
@interface CSPTransitionsViewController : AHTabBarController<ECSlidingViewControllerDelegate>

//left menu button to display the left menu page
- (IBAction)menuButtonTapped:(id)sender;
//get the default  dash view, namely the first page control in the tab bar control
- (CSPDefaultPageViewController *)getFirstTabItem;
@end
