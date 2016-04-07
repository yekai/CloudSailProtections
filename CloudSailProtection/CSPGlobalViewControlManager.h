//
//  CSPGlobalViewControlManager.h
//  CloudSailProtection
//
//  Created by Ice on 11/16/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECSlidingViewController.h"
#import "CSPWarningViewController.h"
#import "CSPTransitionsViewController.h"
#import "CSPMenuViewController.h"
@interface CSPGlobalViewControlManager : NSObject

+ (CSPGlobalViewControlManager*)sharedManager;
- (ECSlidingViewController*)rootCotrol;
- (CSPDefaultPageViewController *)getDefaultPageControl;
- (CSPTransitionsViewController *)getTransitionControl;
- (CSPMenuViewController *)getMenuViewControl;
- (BOOL)getReloadStatus;
- (void)setReloadStatus:(BOOL)status;
@end
