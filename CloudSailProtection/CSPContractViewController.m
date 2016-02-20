//
//  CSPContractViewController.m
//  CloudSailProtection
//
//  Created by Ice on 12/12/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "CSPContractViewController.h"
#import "CSPGlobalViewControlManager.h"
#import "ContractTableViewCell.h"
#import "CSPGlobalViewControlManager.h"
#import "MBProgressHUD.h"
#import "Post.h"
#import "Agreements.h"
#import "CSPLoginViewController.h"
#import "UIStoryBoard+New.h"

@interface CSPContractViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *contracts;
@end

@implementation CSPContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"合同信息";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationDummy"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenu)];
    
    self.tableView.rowHeight = 200.0f;
    self.tableView.separatorColor = [UIColor colorWithRed:201/255.0 green:202/255.0 blue:233/255.0 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self reloadAgreements];
}

//create pull request to load server contracts
- (void)reloadAgreements
{
    __block CSPContractViewController *weakSelf = self;
    if (!_contracts)
    {
        _contracts = [NSMutableArray array];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [Post getAgreementsInfoWithBlock:^(NSArray *agreementsArray) {
            [agreementsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [weakSelf.contracts addObject:[[Agreements alloc]initWithAgreementsAttribute:obj]];
            }];
            
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.tableView reloadData];
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
    return [_contracts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContractTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContractTableViewCellIdentifier" forIndexPath:indexPath];
    
    Agreements *agreement = _contracts[indexPath.row];
    [cell setValueFromAgreements:agreement];
    
    return cell;
}

@end
