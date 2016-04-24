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
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (nonatomic, strong) EGORefreshTableHeaderView *egoRefreshTableHeaderView;
@property (nonatomic, assign) BOOL isRefreshing;

@property (nonatomic, strong) LoadMoreTableFooterView *loadMoreTableFooterView;
@property (nonatomic, assign) BOOL isLoadMoreing;
@property (nonatomic, assign) NSInteger page;
@end

@implementation CSPWarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最新告警";
    UIBarButtonItem *close = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(closeSelf)];
    UIBarButtonItem *unit = [[UIBarButtonItem alloc]initWithTitle:@"告警统计" style:UIBarButtonItemStylePlain target:self action:@selector(presentWarning:)];
    self.navigationItem.rightBarButtonItems = @[close,unit];
    
    _isRefreshing = NO;
    
    self.page = 1;
    self.errorView.hidden = YES;

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

- (void)reloadLatestNewWarning
{
    [_egoRefreshTableHeaderView refreshLastUpdatedDate];
    if (!_warningArray)
    {
        _warningArray = [NSMutableArray array];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block NSMutableArray *weakWaringArray = _warningArray;
    __block CSPWarningViewController *weakSelf = self;
    
    _isRefreshing = YES;
    
    [Post getAlarmsForPage:1
           andSuccessBlock:^(NSArray *alarmsArray)
    {
        if ([alarmsArray isEqual:[NSNull null]] || alarmsArray.count == 0)
        {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            self.errorView.hidden = _warningArray.count != 0;
            return ;
        }
        
        NSMutableArray *tempArray = [NSMutableArray array];
        [alarmsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Alarm *alarm = [[Alarm alloc]initWithAlarmAttributes:obj];
            [tempArray addObject:alarm];
        }];
        
        if (weakWaringArray.count > 0 && tempArray.count > 0)
        {
            Alarm *firstAlarm = weakWaringArray[0];
            NSString *firstAlarmId = firstAlarm.alarmId;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"alarmId == %@", firstAlarmId];
            NSArray *filteredArray = [tempArray filteredArrayUsingPredicate:predicate];
            if (!filteredArray || filteredArray.count == 0)
            {
                NSMutableIndexSet *set = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tempArray.count)];
                [weakWaringArray insertObjects:tempArray atIndexes:set];
            }
            else
            {
                Alarm *existAlarm = filteredArray[0];
                NSInteger index = -1;
                
                for (int i = 0; i < tempArray.count; i++)
                {
                    if ([[tempArray[i] alarmId] isEqualToString:existAlarm.alarmId])
                    {
                        index = i;
                        break;
                    }
                }
                if (index != 0)
                {
                    NSArray *subArray = [tempArray subarrayWithRange:NSMakeRange(0, index)];
                    NSMutableIndexSet *set = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, subArray.count)];
                    [weakWaringArray insertObjects:subArray atIndexes:set];
                }
            }
        }
        else
        {
            [weakWaringArray addObjectsFromArray:tempArray];
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
               weakSelf.errorView.hidden = weakWaringArray.count != 0;
           }];
}

//create pull request to get the server alarm history data
- (void)loadMoreWarning
{
    if (self.page == 1)
    {
        self.page += 1;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block NSMutableArray *weakWaringArray = _warningArray;
    __block CSPWarningViewController *weakSelf = self;
    
    _isLoadMoreing = YES;
    
    [Post getAlarmsForPage:self.page
           andSuccessBlock:^(NSArray *alarmsArray)
     {
         if ([alarmsArray isEqual:[NSNull null]])
         {
             [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
             self.errorView.hidden = _warningArray.count != 0;
             return ;
         }
         
         [alarmsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             Alarm *alarm = [[Alarm alloc]initWithAlarmAttributes:obj];
             [weakWaringArray addObject:alarm];
         }];
         
         if (alarmsArray != 0)
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
               weakSelf.errorView.hidden = weakWaringArray.count != 0;
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
    return [_warningArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WarningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WarningTableViewCellIdentifier" forIndexPath:indexPath];
    
    Alarm *alarm = _warningArray[indexPath.row];
    [cell setValueForWarningTableCellWithAlarm:alarm];
    
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
    [self reloadLatestNewWarning];
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
    [self loadMoreWarning];
}
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView*)view
{
    return _isLoadMoreing;
}



@end
