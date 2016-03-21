//
//  CSPDeviceTypeCategoryViewController.m
//  CloudSailProtection
//
//  Created by Ice on 3/20/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import "CSPDeviceTypeCategoryViewController.h"
#import "CSPGlobalViewControlManager.h"
#import "Post.h"
#import "DeviceTypeCategory.h"
#import "DeviceCategoryCollectionViewCell.h"
#import "MBProgressHUD.h"
#import "CloudUtility.h"
#import "CSPLoginViewController.h"
#import "UIStoryBoard+New.h"
#import "CSPMyDevicesCollectionViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CSPDeviceTypeCategoryViewController ()
@property (nonatomic, strong) NSMutableArray *devicesArray;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@end

@implementation CSPDeviceTypeCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadDeviceInfos];
    self.title = @"设备类别";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationDummy"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenu)];
}

//create pull request to load related device info for customer
- (void)reloadDeviceInfos
{
    __block CSPDeviceTypeCategoryViewController *weakSelf = self;
    
    if (!_devicesArray)
    {
        _devicesArray = [NSMutableArray array];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [Post getDeviceType1WithBlock:^(NSArray *deviceInfoArray) {
            [deviceInfoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DeviceTypeCategory *deviceObj = [[DeviceTypeCategory alloc]initWithDict:obj];
                [weakSelf.devicesArray addObject:deviceObj];
            }];
            //display the related device collection items
            [weakSelf.collectionView reloadData];
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

- (void)toggleMenu
{
    [[[CSPGlobalViewControlManager sharedManager]rootCotrol] anchorTopViewToRightAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.devicesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DeviceCategoryCollectionViewCell *cell = (DeviceCategoryCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"DeviceTypeCategoryCellIdentifier" forIndexPath:indexPath];
    
    DeviceTypeCategory *deviceObj = (DeviceTypeCategory*)(self.devicesArray[indexPath.row]);
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[deviceObj url]]
                  placeholderImage:nil options:0];
    cell.categoryName.text = [NSString stringWithFormat:@"%@(%@)",deviceObj.typeName, deviceObj.typeCount];
    // Configure the cell
    
    return cell;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceTypeCategory *deviceObj = (DeviceTypeCategory*)(self.devicesArray[indexPath.row]);
    
    if ([deviceObj.typeCount floatValue] == 0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注意" message:@"该设备类别数目为0." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    CSPMyDevicesCollectionViewController *myDevice = [UIStoryboard instantiateControllerWithIdentifier:NSStringFromClass(CSPMyDevicesCollectionViewController.class)];
    myDevice.deviceObj = deviceObj;
    [self.navigationController pushViewController:myDevice animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger width = (self.view.bounds.size.width - 30) / 2;
    return CGSizeMake(width, width);
}

@end
