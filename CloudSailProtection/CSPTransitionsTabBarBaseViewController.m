//
//  CSPTransitionsBaseViewController.m
//  CloudSailProtection
//
//  Created by Ice on 11/16/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "CSPTransitionsTabBarBaseViewController.h"
#import "CSPGlobalViewControlManager.h"
#import "ContactsTableViewController.h"
#import "Post.h"
#import "Notice.h"
#import "SYQRCodeViewController.h"
#import "SessionManager.h"
#import "CSPLoginViewController.h"
#import "UIStoryBoard+New.h"

static NSMutableArray *noticeArray = nil;

@interface CSPTransitionsTabBarBaseViewController ()
@end

@implementation CSPTransitionsTabBarBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //reload notice to get the notice pull request response
    self.headerBar.delegate = self;
    [self.headerBar reloadNotice];
}

//make a notice pull request to get server notice response
- (void)reloadNotices
{
    if (![[SessionManager sharedManager]isLoggedIn])
    {
        return;
    }
    
    if (!noticeArray)
    {
        noticeArray = [NSMutableArray array];
    }
    
    
    if ([noticeArray count] == 0)
    {
        __block CSPTransitionsTabBarBaseViewController *weakSelf =self;
        __block NSMutableArray *_noticeArray = noticeArray;
        //create notice pull request
        [Post getCorporationNoticeWithBlock:^(NSArray *noticeArray) {
            //parse notice response and set notice array
            [noticeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [_noticeArray addObject:[[Notice alloc]initWithAttribute:obj]];
            }];
            //set header bar notice with notice response
            [weakSelf.headerBar reloadNotice];
        }
                            andFailureBlock:^{
            CSPLoginViewController *login = [UIStoryboard instantiateControllerWithIdentifier:NSStringFromClass([CSPLoginViewController class])];
            [[[CSPGlobalViewControlManager sharedManager]rootCotrol]presentViewController:login animated:YES completion:nil];
        }];
    }
    else
    {
        [_headerBar reloadNotice];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadNotices];
    
    //set tab bar view status bar background color
    if (![self.view viewWithTag:0XAAA])
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
        view.backgroundColor = [UIColor colorWithRed:104/255.0 green:165/255.0 blue:205/255.0 alpha:1];
        view.tag = 0XAAA;
        [self.view addSubview:view];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//notice data for header bar
- (NSArray *)dataSourceForScrollView
{
    if (noticeArray.count != 0)
    {
        Notice *notice = noticeArray[0];
        NSString *content = notice.content;
        return @[content];
    }
    
    return nil;
}

//tap on action bar event
- (void)didSelectActionBarItemAtIndex:(NSUInteger)index
{
    //display left page menu
    if (index == 0)
    {
        [[[CSPGlobalViewControlManager sharedManager]rootCotrol] anchorTopViewToRightAnimated:YES];
    }
    
    //display the SaoYiSao page view
    if (index == 2)
    {
        SYQRCodeViewController *qrcodevc = [[SYQRCodeViewController alloc] init];
        qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeViewController *aqrvc,NSString *qrString){
            [aqrvc dismissViewControllerAnimated:NO completion:nil];
        };
        qrcodevc.SYQRCodeFailBlock = ^(SYQRCodeViewController *aqrvc){
            [aqrvc dismissViewControllerAnimated:NO completion:nil];
        };
        qrcodevc.SYQRCodeCancleBlock = ^(SYQRCodeViewController *aqrvc){
            [aqrvc dismissViewControllerAnimated:NO completion:nil];
        };
        [self presentViewController:qrcodevc animated:YES completion:nil];
    }
    
    //display the contacts
    if (index == 3)
    {
        ContactsTableViewController *contacts = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ContactsTableViewController"];
        UINavigationController *navControl = [[UINavigationController alloc]initWithRootViewController:contacts];
        [self presentViewController:navControl animated:YES completion:nil];
    }
    
    if (index == 4)
    {
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            [storage deleteCookie:cookie];
        }
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        CSPLoginViewController *login = [UIStoryboard instantiateControllerWithIdentifier:NSStringFromClass([CSPLoginViewController class])];
        [[[CSPGlobalViewControlManager sharedManager]rootCotrol]presentViewController:login animated:YES completion:nil];
    }
}

- (void)didSelectNoticeAtIndex:(NSUInteger)index
{
    
}

@end
