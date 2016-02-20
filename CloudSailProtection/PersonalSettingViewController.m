//
//  PersonalSettingViewController.m
//  CloudSailProtection
//
//  Created by Ice on 12/20/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "PersonalSettingViewController.h"
#import "PersonalSettingsTableViewCell.h"
#import "CSPGlobalViewControlManager.h"
#import "SessionManager.h"
#import "Post.h"
#import "User.h"
#import "CSPLoginViewController.h"
#import "UIStoryBoard+New.h"
#import "MBProgressHUD.h"

@interface PersonalSettingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *settings;
@end

@implementation PersonalSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人设置";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationDummy"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenu)];
    [self reloadHostSettings];
    
}

//create pull request to load customer login info
- (void)reloadHostSettings
{
    if (!_settings)
    {
        [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
        __block PersonalSettingViewController *weakSelf = self;
        [Post getHostInfoWithBlock:^(NSArray *hostInfoArray) {
            User *user = [[SessionManager sharedManager]user];
            [user setUserLoginInfo:hostInfoArray[0]];
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            weakSelf.settings = @[@{@"公司：":user.company},@{@"账号：":user.loginId},@{@"开通时间：":user.opentime},@{@"最后一次登录：":user.lastlogintime}];
            [weakSelf.tableView reloadData];
        } andFailureBlock:^{
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_settings count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonalSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalSettingsTableViewCellIdentifier" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *dict = _settings[indexPath.row];
    [cell setValueForPersonalSettingsCell:dict];
    
    return cell;
}


@end
