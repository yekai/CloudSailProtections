//
//  CSPMenuViewController.h
//  CloudSailProtection
//
//  Created by Ice on 11/13/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSPTransitionsViewController;

/**
 *@brief the left menu page control for sliding view
 *
 */
@interface CSPMenuViewController : UIViewController<UITableViewDataSource>
//the menu cell table
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//get the root control view in menu page
- (CSPTransitionsViewController *)getTabBarView;
@end
