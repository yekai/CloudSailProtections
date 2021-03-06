//
//  CSPRoutingViewController.m
//  CloudSailProtection
//
//  Created by Ice on 1/3/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import "CSPRoutingViewController.h"
#import "RoutingsTableViewCell.h"
#import "MBProgressHUD.h"
#import "Post.h"
#import "CSPLoginViewController.h"
#import "RoutingObj.h"
#import "CSPGlobalViewControlManager.h"
#import "UIStoryBoard+New.h"
#import "CloudUtility.h"

@interface CSPRoutingViewController ()<UITableViewDataSource, UITableViewDelegate,RoutingsTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *routingArray;
@property (nonatomic, strong) NSMutableArray *todayRouting;
@property (nonatomic, strong) NSMutableArray *yesterdayRouting;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, copy) NSString *routingName;
@property (weak, nonatomic) IBOutlet UILabel *routingNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *routingAboveImage;
@property (weak, nonatomic) IBOutlet UIView *leftLineView;
@property (weak, nonatomic) IBOutlet UIView *errorView;

@end

@implementation CSPRoutingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"巡检";
    
    UIBarButtonItem *close = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(closeSelf)];
    
    self.navigationItem.rightBarButtonItems = @[close];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadRoutings];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)closeSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadRoutings
{
    
    if (!self.routingArray)
    {
        self.routingArray = [NSMutableArray array];
    }
    else
    {
        [self.routingArray removeAllObjects];
    }
    __block CSPRoutingViewController *weakSelf = self;
    __block NSMutableArray *set = [NSMutableArray array];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.routingAboveImage.hidden = YES;
    self.routingNameLabel.hidden = YES;
    self.leftLineView.hidden = YES;
    self.errorView.hidden = YES;
    [Post getRoutiningInfoByDate:self.segmentView.selectedSegmentIndex == 0
                 andSuccessBlock:^(NSDictionary *routingDict)
     {
         if ([routingDict isEqual:[NSNull null]] || [routingDict[@"tdata"]isEqual:[NSNull null]])
         {
             [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
             self.errorView.hidden = NO;
             return ;
         }
         NSString *routingName = routingDict[@"name"];
         weakSelf.routingName = routingName;
        [routingDict[@"tdata"] enumerateObjectsUsingBlock:^(id  _Nonnull routingObj, NSUInteger routingIdx, BOOL * _Nonnull stopFirst) {
            NSString *time = [CloudUtility stringForRoutingDateWithRoutingTime: routingObj[@"time"]];
            [routingObj[@"devs"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
                RoutingObj *routing = [[RoutingObj alloc]initWithRoutingAttributes:obj];
                if (![set containsObject:time])
                {
                    [set addObject:time];
                    NSMutableArray *keyArray = [NSMutableArray array];
                    [keyArray addObject:routing];
                    [weakSelf.routingArray addObject:@{time:keyArray}];
                }
                else
                {
                    NSMutableArray *keyArray = [weakSelf getRoutingValuesByKey:time];
                    [keyArray addObject:routing];
                }
            }];
        }];
        [weakSelf performSelector:@selector(reloadRoutingTable) withObject:nil afterDelay:0];
        
    } andFailureBlock:^{
        [weakSelf reloadRoutingTable];
    }];
}

- (NSMutableArray *)getRoutingValuesByKey:(NSString *)key
{
    for (int i = 0 ; i < self.routingArray.count; i++)
    {
        NSDictionary *dict = self.routingArray[i];
        if ([[dict.allKeys lastObject] isEqualToString:key])
        {
            return dict[key];
        }
    }
    
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (IBAction)segmentValueChanged:(id)sender
{
    self.selectedRow = 0;
    [self.routingArray removeAllObjects];
    [self.tableView reloadData];
    [self reloadRoutings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tableViewCellIdentifier = nil;
    RoutingsTableViewCell *cell = nil;
    if (self.routingArray.count == 0)
    {
        tableViewCellIdentifier = @"RoutingNoInfoIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
        
        return cell;
    }
        
    tableViewCellIdentifier = self.selectedRow == indexPath.row ? @"SelectedRoutingIdentifier" : @"UnSelectedRoutingIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    [cell setDelegate:self];
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *dict = [self.routingArray objectAtIndex:indexPath.row];
    cell.timeLabel.text = [dict.allKeys lastObject];
    if (self.selectedRow == indexPath.row)
    {
        NSDictionary *keyDict = @{@"cell":cell,@"value":dict.allValues.lastObject};
        [self performSelector:@selector(setRoutingValueWithCell:) withObject:keyDict afterDelay:0.1];
    }
    
    return cell;
}

- (void)setRoutingValueWithCell:(NSDictionary *)dict
{
    RoutingsTableViewCell *cell = dict[@"cell"];
    NSMutableArray *keyArray = dict[@"value"];
    [cell setRoutingTableViewCellData:keyArray];
}

- (void)reloadRoutingTable
{
    if (self.routingArray.count != 0)
    {
        self.routingNameLabel.text = self.routingName;
        self.routingAboveImage.hidden = NO;
        self.routingNameLabel.hidden = NO;
        self.leftLineView.hidden = NO;
        [self.tableView reloadData];
    }
    else
    {
        self.errorView.hidden = NO;
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.routingArray objectAtIndex:indexPath.row];
    NSMutableArray *keyValue = dict.allValues.lastObject;
    return self.selectedRow == indexPath.row ? 60 + (keyValue.count + 1) * 20 : 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.routingArray count];
    return count;
}

- (void)timePointBtnTapped:(RoutingsTableViewCell *)cell
{
    self.selectedRow = [self.tableView indexPathForCell:cell].row;
    [self.tableView reloadData];
}

@end
