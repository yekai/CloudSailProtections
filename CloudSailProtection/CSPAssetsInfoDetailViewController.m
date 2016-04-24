//
//  CSPAssetsInfoDetailViewController.m
//  CloudSailProtection
//
//  Created by Ice on 3/21/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import "CSPAssetsInfoDetailViewController.h"
#import "MBProgressHUD.h"
#import "Post.h"
#import "DeviceAssets.h"
#import "CSPLoginViewController.h"
#import "UIStoryBoard+New.h"
#import "CSPGlobalViewControlManager.h"
#import "DeviceInfoObj.h"
#import "DeviceAssetsInfoTableViewCell.h"

@interface CSPAssetsInfoDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *assetsArrayList;
@end

@implementation CSPAssetsInfoDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设备信息";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadAssetsArrayList];
}

//create pull request to get the server alarm history data
- (void)reloadAssetsArrayList
{
    _assetsArrayList = [NSMutableArray array];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block NSMutableArray *weakWaringArray = _assetsArrayList;
    __block CSPAssetsInfoDetailViewController *weakSelf = self;
    
    [Post getAssetInfosWithAssetTypeId:self.assets.assetId
                            assetCount:self.assets.deviceCount
                          successBlock:^(NSArray *alarmLevel)
    {
        if ([alarmLevel isEqual:[NSNull null]])
        {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            return ;
        }
        [alarmLevel enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DeviceInfoObj *infoObj = [[DeviceInfoObj alloc]initWithDeviceAttribute:obj];
            [weakWaringArray addObject:infoObj];
        }];
        
        [weakSelf.tableView reloadData];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }
                       andFailureBlock:^{
                           
        CSPLoginViewController *login = [UIStoryboard instantiateControllerWithIdentifier:NSStringFromClass([CSPLoginViewController class])];
                           [[[CSPGlobalViewControlManager sharedManager]rootCotrol]presentViewController:login animated:YES completion:nil];
                       }];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_assetsArrayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceAssetsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceAssetsInfoTableViewCellIdentifier" forIndexPath:indexPath];
    
    DeviceInfoObj *infoObj = _assetsArrayList[indexPath.row];
    [cell configureWithDeviceInfoObj:infoObj];
    
    return cell;
}

- (void)displayHomeViewWithTabIndex:(NSInteger)index
{
    TabsBarBaseViewController __weak *weakSelf = self.navigationController.viewControllers[0];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self displayHomeWithIndex:@(index) andTabViewControl:weakSelf];
}

- (void)displayHomeWithIndex:(NSNumber*)index andTabViewControl:(TabsBarBaseViewController*)tabView
{
    __weak NSNumber *numberIndex = index;
    [[[CSPGlobalViewControlManager sharedManager]rootCotrol] anchorTopViewToRightAnimated:NO onComplete:^{
        [tabView performSelector:@selector(displayHomeViewWithIndex:) withObject:numberIndex afterDelay:0.5];
    }];
}


@end
