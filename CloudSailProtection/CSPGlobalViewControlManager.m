//
//  CSPGlobalViewControlManager.m
//  CloudSailProtection
//
//  Created by Ice on 11/16/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "CSPGlobalViewControlManager.h"
#import "CSPMenuViewController.h"
#import "CSPTransitionsViewController.h"
#import "CSPDefaultPageViewController.h"

@implementation CSPGlobalViewControlManager

+ (CSPGlobalViewControlManager *)sharedManager
{
    static CSPGlobalViewControlManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[CSPGlobalViewControlManager alloc] init];
    });
    
    return _sharedManager;

}

- (ECSlidingViewController *)rootCotrol
{
    return (ECSlidingViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
}

- (CSPTransitionsViewController *)getTransitionControl
{
    ECSlidingViewController *slidingControl = [self rootCotrol];
    CSPMenuViewController *menuControl = (CSPMenuViewController*)slidingControl.underLeftViewController;
    return [menuControl getTabBarView];
}

- (CSPDefaultPageViewController *)getDefaultPageControl
{
    CSPTransitionsViewController *transitionControl = [self getTransitionControl];
    CSPDefaultPageViewController *alarmControl = [transitionControl getFirstTabItem];
    
    return alarmControl;
}

- (CSPMenuViewController *)getMenuViewControl
{
    ECSlidingViewController *slidingControl = [self rootCotrol];
    return (CSPMenuViewController*)slidingControl.underLeftViewController;
}
@end
