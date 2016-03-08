//
//  CSPMyEquipmentRoomViewController.m
//  CloudSailProtection
//
//  Created by Ice on 11/14/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "CSPBreakdownsViewController.h"
#import "BreakdownsTableViewCell.h"
#import "CSPPUETrendGraphViewController.h"
#import "MBProgressHUD.h"
#import "Fault.h"
#import "Post.h"
#import "CSPLoginViewController.h"
#import "CSPGlobalViewControlManager.h"
#import "UIStoryBoard+New.h"

@interface CSPBreakdownsViewController ()
@property (nonatomic, weak) IBOutlet UITableView        *tableView;
@property (nonatomic, strong) NSMutableArray *breakdowns;
@end

@implementation CSPBreakdownsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.title = @"故障";
    UIBarButtonItem *close = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(closeSelf)];
    UIBarButtonItem *unit = [[UIBarButtonItem alloc]initWithTitle:@"故障统计" style:UIBarButtonItemStylePlain target:self action:@selector(presentPueTrendGraphy:)];
    self.navigationItem.rightBarButtonItems = @[close,unit];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadFaults];
}

- (IBAction)presentPueTrendGraphy:(id)sender
{
    CSPPUETrendGraphViewController *pue = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CSPPUETrendGraphViewController"];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:pue];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)closeSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//create breakdown pull request to get the server response to display the breakdowns table view
- (void)reloadFaults
{
    __block CSPBreakdownsViewController *weakSelf = self;
    _breakdowns = [NSMutableArray array];
    __block NSMutableArray *weakBreakdowns = _breakdowns;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [Post getFaultsWithBlock:^(NSArray *faultsArray) {
        [faultsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Fault *fault = [[Fault alloc]initWithFaultAttributes:obj];
            [weakBreakdowns addObject:fault];
        }];
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableView reloadData];
    }
             andFailureBlock:^{
        CSPLoginViewController *login = [UIStoryboard instantiateControllerWithIdentifier:NSStringFromClass([CSPLoginViewController class])];
        [[[CSPGlobalViewControlManager sharedManager]rootCotrol]presentViewController:login animated:YES completion:nil];
    }];
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
    return [_breakdowns count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BreakdownsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BreakdownsTableViewCellIdentifier" forIndexPath:indexPath];
    
    [cell setValueFromFault:_breakdowns[indexPath.row]];
    
    return cell;
}
@end
