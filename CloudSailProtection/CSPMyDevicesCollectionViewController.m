//
//  CSPMyDevicesCollectionViewController.m
//  CloudSailProtection
//
//  Created by Ice on 12/12/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "CSPMyDevicesCollectionViewController.h"
#import "MyDeviceCollectionViewCell.h"
#import "CSPGlobalViewControlManager.h"
#import "Post.h"
#import "DeviceAssets.h"
#import "MBProgressHUD.h"
#import "CloudUtility.h"
#import "CSPLoginViewController.h"
#import "UIStoryBoard+New.h"
#import "DeviceTypeCategory.h"
#import "CSPAssetsInfoDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface CSPMyDevicesCollectionViewController ()
@property (nonatomic, strong) NSMutableArray *devicesArray;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@end

@implementation CSPMyDevicesCollectionViewController

static NSString * const reuseIdentifier = @"MyDeviceCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadDeviceInfos];
    self.title = @"我的设备";
}

//create pull request to load related device info for customer
- (void)reloadDeviceInfos
{
    __block CSPMyDevicesCollectionViewController *weakSelf = self;
    
    if (!_devicesArray)
    {
        _devicesArray = [NSMutableArray array];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [Post getDeviceType2WithType1:self.deviceObj.typeId
                                count:self.deviceObj.typeCount
                         successBlock:^(NSArray *deviceInfoArray) {
             if ([deviceInfoArray isEqual:[NSNull null]])
             {
                 [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                 return ;
             }
            [deviceInfoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DeviceAssets *deviceObj = [[DeviceAssets alloc]initWithDeviceAssetsDict:obj];
                [weakSelf.devicesArray addObject:deviceObj];
            }];
            //display the related device collection items
            [weakSelf.collectionView reloadData];
            [weakSelf performSelector:@selector(createBadgeView) withObject:nil afterDelay:0.5];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
                     andFailureBlock:^{
            CSPLoginViewController *login = [UIStoryboard instantiateControllerWithIdentifier:NSStringFromClass([CSPLoginViewController class])];
            [[[CSPGlobalViewControlManager sharedManager]rootCotrol]presentViewController:login animated:YES completion:nil];
        }];
    }
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

- (void)createBadgeView
{
    __weak UICollectionView *weakCollectionView = self.collectionView;
    [_devicesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DeviceAssets *category = (DeviceAssets*)obj;
        MyDeviceCollectionViewCell *cell = (MyDeviceCollectionViewCell*)[weakCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
        if ([category.count floatValue] != 0.0)
        {
            [cell configureCellWithBadgeNumber:[@([category.count floatValue]) stringValue]];
        }
    }];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.devicesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyDeviceCollectionViewCell *cell = (MyDeviceCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    DeviceAssets *deviceObj = (DeviceAssets*)(self.devicesArray[indexPath.row]);
    NSString *imageName = [deviceObj getImageName];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[deviceObj url]]
                  placeholderImage:[UIImage imageNamed:imageName] options:0];
    cell.deviceName.text = [NSString stringWithFormat:@"%@(%@)",deviceObj.assetName, deviceObj.deviceCount];
    // Configure the cell
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceAssets *deviceObj = (DeviceAssets*)(self.devicesArray[indexPath.row]);
    MyDeviceCollectionViewCell *cell = (MyDeviceCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if ([deviceObj.deviceCount floatValue] == 0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注意" message:@"该设备数目为0." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    [cell hideBadge];
    CSPAssetsInfoDetailViewController *myDevice = [UIStoryboard instantiateControllerWithIdentifier:NSStringFromClass(CSPAssetsInfoDetailViewController.class)];
    myDevice.assets = deviceObj;
    [self.navigationController pushViewController:myDevice animated:YES];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return [CloudUtility isIphone6S] ? 30 : 10;
}

- (void)displayHomeViewWithTabIndex:(NSInteger)index
{
    TabsBarBaseViewController __weak *weakSelf = self.navigationController.viewControllers[0];
    [self.navigationController popViewControllerAnimated:NO];
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
