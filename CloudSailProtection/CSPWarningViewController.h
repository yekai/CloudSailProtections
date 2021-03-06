//
//  CSPWarningViewController.h
//  CloudSailProtection
//
//  Created by Ice on 12/3/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPTransitionsTabBarBaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"

@interface CSPWarningViewController : CSPTransitionsTabBarBaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate, LoadMoreTableFooterDelegate>

@end
