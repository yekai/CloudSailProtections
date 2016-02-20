//
//  CSPPatrolExamineViewController.m
//  CloudSailProtection
//
//  Created by Ice on 11/14/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "CSPEnergyConsumptionViewController.h"
#import "EnergyConsumptionTableViewCell.h"
#import "CSPEnergyConsumptionPUEViewController.h"
#import "UIStoryBoard+New.h"
#import "MBProgressHUD.h"
#import "PUEObj.h"
#import "Post.h"
#import "CSPPUETrendGraphViewController.h"
#import "CSPLoginViewController.h"
#import "CSPGlobalViewControlManager.h"


@interface CSPEnergyConsumptionViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentView;
@property (nonatomic, strong) NSMutableArray *energyConsumptions;

@end

@implementation CSPEnergyConsumptionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"能耗";
    
     UIBarButtonItem *close = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeSelf)];
    
    UIBarButtonItem *pue = [[UIBarButtonItem alloc]initWithTitle:@"PUE趋势图" style:UIBarButtonItemStylePlain target:self action:@selector(presentPueTrendGraphy)];
    
    self.navigationItem.rightBarButtonItems = @[close,pue];
    
    [self reloadPUEHisData];
}

//create pue history dat by position pull request to display the energy consumption table view
- (void)reloadPUEHisData
{
    if (!_energyConsumptions)
    {
        _energyConsumptions = [NSMutableArray array];
    }
    else
    {
        [_energyConsumptions removeAllObjects];
    }
    __block NSMutableArray *weakEnergyConsumptions = _energyConsumptions;
    __block UITableView *weakTable = _tableView;
    NSString *type = @"Day";
    if (self.segmentView.selectedSegmentIndex == 1)
    {
        type = @"Mon";
    }
    else if (self.segmentView.selectedSegmentIndex == 2)
    {
        type = @"Yea";
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Post getPUEHisDataByPositionWithReportType:type
                                   successBlock:^(NSArray *puesArray){
        [puesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PUEObj *pue = [[PUEObj alloc]initWithPUEAttribute:obj];
            [weakEnergyConsumptions addObject:pue];
        }];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [weakTable reloadData];
    }
                                andFailureBlock:^{
        CSPLoginViewController *login = [UIStoryboard instantiateControllerWithIdentifier:NSStringFromClass([CSPLoginViewController class])];
        [[[CSPGlobalViewControlManager sharedManager]rootCotrol]presentViewController:login animated:YES completion:nil];
    }];
}

- (void)closeSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentPueTrendGraphy
{
    CSPPUETrendGraphViewController *pue = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CSPPUETrendGraphViewController"];
    [self.navigationController pushViewController:pue animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentValueChanged:(id)sender
{
    [self reloadPUEHisData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_energyConsumptions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EnergyConsumptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EnergyConsumptionTableViewCellIdentifier" forIndexPath:indexPath];
    
    [cell setValueFromPueObj:_energyConsumptions[indexPath.row]];
    
    return cell;
}


@end