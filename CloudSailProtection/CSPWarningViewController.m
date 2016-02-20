//
//  CSPWarningViewController.m
//  CloudSailProtection
//
//  Created by Ice on 12/3/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "CSPWarningViewController.h"
#import "WarningTableViewCell.h"
#import "WarningUnitViewController.h"
#import "Post.h"
#import "Alarm.h"
#import "MBProgressHUD.h"
#import "CSPDefaultPageViewController.h"
#import "UIStoryBoard+New.h"
#import "CSPLoginViewController.h"
#import "UIStoryBoard+New.h"
#import "CSPGlobalViewControlManager.h"

@interface CSPWarningViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *warningArray;
@end

@implementation CSPWarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最新告警";
    UIBarButtonItem *close = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeSelf)];
    UIBarButtonItem *unit = [[UIBarButtonItem alloc]initWithTitle:@"告警统计" style:UIBarButtonItemStylePlain target:self action:@selector(presentWarning:)];
    self.navigationItem.rightBarButtonItems = @[close,unit];
    [self reloadAlarmWarning];
}

- (IBAction)presentWarning:(id)sender
{
    WarningUnitViewController *waningUnit = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"WarningUnitViewController"];
    UINavigationController *naviControl = [[UINavigationController alloc]initWithRootViewController:waningUnit];
    [self presentViewController:naviControl animated:YES completion:nil];
}

- (void)closeSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//create pull request to get the server alarm history data
- (void)reloadAlarmWarning
{
    if (!_warningArray)
    {
        _warningArray = [NSMutableArray array];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __block NSMutableArray *weakWaringArray = _warningArray;
        __block CSPWarningViewController *weakSelf = self;
        
        [Post getAlarmsWithBlock:^(NSArray *alarmsArray) {
            [alarmsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Alarm *alarm = [[Alarm alloc]initWithAlarmAttributes:obj];
                [weakWaringArray addObject:alarm];
            }];
            
            [weakSelf.tableView reloadData];
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        }
                 andFailureBlock:^{
            CSPLoginViewController *login = [UIStoryboard instantiateControllerWithIdentifier:NSStringFromClass([CSPLoginViewController class])];
            [[[CSPGlobalViewControlManager sharedManager]rootCotrol]presentViewController:login animated:YES completion:nil];
        }];
    }
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
    return [_warningArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WarningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WarningTableViewCellIdentifier" forIndexPath:indexPath];
    
    Alarm *alarm = _warningArray[indexPath.row];
    [cell setValueForWarningTableCellWithAlarm:alarm];
    
    return cell;
}


@end
