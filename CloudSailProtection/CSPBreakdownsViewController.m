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
@property (weak, nonatomic) IBOutlet UIView *errorView;

@property (nonatomic, strong) EGORefreshTableHeaderView *egoRefreshTableHeaderView;
@property (nonatomic, assign) BOOL isRefreshing;

@property (nonatomic, strong) LoadMoreTableFooterView *loadMoreTableFooterView;
@property (nonatomic, assign) BOOL isLoadMoreing;
@property (nonatomic, assign) NSInteger page;

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
    
    _isRefreshing = NO;
    
    self.page = 1;
    self.errorView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_egoRefreshTableHeaderView)
    {
        [_egoRefreshTableHeaderView egoRefreshScrollViewDataSourceStartManualLoading:self.tableView];
    }
    else
    {
        _egoRefreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height )];
        _egoRefreshTableHeaderView.delegate = self;
        [self.tableView addSubview:_egoRefreshTableHeaderView];
        [_egoRefreshTableHeaderView egoRefreshScrollViewDataSourceStartManualLoading:self.tableView];
    }
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
- (void)reloadLatestFaults
{
    [_egoRefreshTableHeaderView refreshLastUpdatedDate];
    if (!_breakdowns)
    {
        _breakdowns = [NSMutableArray array];
    }
    __block CSPBreakdownsViewController *weakSelf = self;
    __block NSMutableArray *weakBreakdowns = _breakdowns;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _isRefreshing = YES;

    [Post getFaultsForPage:1
           andSuccessBlock:^(NSArray *faultsArray) {
        if ([faultsArray isEqual:[NSNull null]] || faultsArray.count == 0)
        {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            self.errorView.hidden = _breakdowns.count != 0;
            return ;
        }
        NSMutableArray *tempArray = [NSMutableArray array];
        [faultsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Fault *fault = [[Fault alloc]initWithFaultAttributes:obj];
            [tempArray addObject:fault];
        }];
        
        if (weakBreakdowns.count > 0 && tempArray.count > 0)
        {
           Fault *firstFault = weakBreakdowns[0];
           NSString *firstFaultId = firstFault.faultId;
           NSPredicate *predicate = [NSPredicate predicateWithFormat:@"faultId == %@", firstFaultId];
           NSArray *filteredArray = [tempArray filteredArrayUsingPredicate:predicate];
           if (!filteredArray || filteredArray.count == 0)
           {
               NSMutableIndexSet *set = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tempArray.count)];
               [weakBreakdowns insertObjects:tempArray atIndexes:set];
           }
           else
           {
               Fault *existFault = filteredArray[0];
               NSInteger index = -1;
               
               for (int i = 0; i < tempArray.count; i++)
               {
                   if ([[tempArray[i] faultId] isEqualToString:existFault.faultId])
                   {
                       index = i;
                       break;
                   }
               }
               if (index != 0)
               {
                   NSArray *subArray = [tempArray subarrayWithRange:NSMakeRange(0, index)];
                   NSMutableIndexSet *set = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, subArray.count)];
                   [weakBreakdowns insertObjects:subArray atIndexes:set];
               }
           }
        }
        else
        {
           [weakBreakdowns addObjectsFromArray:tempArray];
        }
        [weakSelf.tableView reloadData];
        // complete refreshing
        _isRefreshing = NO;
        //            [self reloadData];
        [_egoRefreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.tableView];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];

        if (_loadMoreTableFooterView == nil)
        {
           _loadMoreTableFooterView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, weakSelf.tableView.contentSize.height, weakSelf.view.frame.size.width, weakSelf.tableView.bounds.size.height)];
           _loadMoreTableFooterView.delegate = weakSelf;
           [weakSelf.tableView addSubview:_loadMoreTableFooterView];
        }
        _loadMoreTableFooterView.frame = CGRectMake(0.0f, weakSelf.tableView.contentSize.height, weakSelf.view.frame.size.width, weakSelf.tableView.bounds.size.height);
    }
             andFailureBlock:^{
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                weakSelf.errorView.hidden = _breakdowns.count != 0;
             }];
}

- (void)loadMoreFaults
{
    if (self.page == 1)
    {
        self.page += 1;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block NSMutableArray *weakBreakdowns = _breakdowns;
    __block CSPBreakdownsViewController *weakSelf = self;
    
    _isLoadMoreing = YES;
    
    [Post getFaultsForPage:self.page
           andSuccessBlock:^(NSArray *faultsArray)
     {
         if ([faultsArray isEqual:[NSNull null]])
         {
             [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
             self.errorView.hidden = _breakdowns.count != 0;
             return ;
         }
         
         [faultsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             Fault *fault = [[Fault alloc]initWithFaultAttributes:obj];
             [weakBreakdowns addObject:fault];
         }];
         
         if (faultsArray != 0)
         {
             self.page += 1;
         }
         
         [weakSelf.tableView reloadData];
         // complete refreshing
         _isLoadMoreing = NO;
         [_loadMoreTableFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
         [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
         
         _loadMoreTableFooterView.frame = CGRectMake(0.0f, self.tableView.contentSize.height, self.view.frame.size.width, self.tableView.bounds.size.height);
     }
           andFailureBlock:^{
               [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
               weakSelf.errorView.hidden = _breakdowns.count != 0;
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

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_egoRefreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_loadMoreTableFooterView loadMoreScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_egoRefreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_loadMoreTableFooterView loadMoreScrollViewDidEndDragging:scrollView];
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadLatestFaults];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _isRefreshing;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

#pragma mark LoadMoreTableFooterDelegate Methods

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView*)view
{
    [self loadMoreFaults];
}
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView*)view
{
    return _isLoadMoreing;
}

@end
