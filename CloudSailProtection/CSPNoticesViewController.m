//
//  CSPNoticesViewController.m
//  CloudSailProtection
//
//  Created by Ice on 12/13/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "CSPNoticesViewController.h"
#import "CSPGlobalViewControlManager.h"
#import "CSPLoginViewController.h"
#import "NoticesTableViewCell.h"
#import "UIStoryBoard+New.h"
#import "MBProgressHUD.h"
#import "Post.h"
#import "Notice.h"


@interface CSPNoticesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *notices;
@end

@implementation CSPNoticesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公告信息";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationDummy"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenu)];
    
    self.tableview.rowHeight = 120.0f;
    self.tableview.separatorColor = [UIColor colorWithRed:201/255.0 green:202/255.0 blue:233/255.0 alpha:1];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self reloadNotices];
}

//create pull request to load remote server notices info
- (void)reloadNotices
{
    __block CSPNoticesViewController *weakSelf = self;
    
    if (!_notices)
    {
        _notices = [NSMutableArray array];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [Post getNoticeHistoryWithBlock:^(NSArray *noticeHistoryArray) {
            [noticeHistoryArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Notice *notice = [[Notice alloc]initWithAttribute:obj];
                [weakSelf.notices addObject:notice];
            }];
            
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.tableview reloadData];
        }
                        andFailureBlock:^{
            CSPLoginViewController *login = [UIStoryboard instantiateControllerWithIdentifier:NSStringFromClass([CSPLoginViewController class])];
            [[[CSPGlobalViewControlManager sharedManager]rootCotrol]presentViewController:login animated:YES completion:nil];
        }];
    }
}

- (void)toggleMenu
{
    [[[CSPGlobalViewControlManager sharedManager]rootCotrol] anchorTopViewToRightAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view removeGestureRecognizer:self.slidingViewController.panGesture];
    
}

- (ECSlidingViewController*)slidingViewController
{
    return [[CSPGlobalViewControlManager sharedManager]rootCotrol];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_notices count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NoticesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticesTableViewCellIdentifier" forIndexPath:indexPath];
    
    Notice *notice = _notices[indexPath.row];
    [cell setValueFromNotice:notice withIndex:indexPath.row + 1];
    
    return cell;
}


@end
