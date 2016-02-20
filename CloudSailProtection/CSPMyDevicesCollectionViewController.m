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
#import "DeviceInfoObj.h"
#import "MBProgressHUD.h"
#import "CloudUtility.h"
#import "CSPLoginViewController.h"
#import "UIStoryBoard+New.h"

@interface CSPMyDevicesCollectionViewController ()
@property (nonatomic, strong) NSMutableArray *devicesArray;
@end

@implementation CSPMyDevicesCollectionViewController

static NSString * const reuseIdentifier = @"MyDeviceCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadDeviceInfos];
    self.title = @"我的设备";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationDummy"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenu)];
}

//create pull request to load related device info for customer
- (void)reloadDeviceInfos
{
    __block CSPMyDevicesCollectionViewController *weakSelf = self;
    
    if (!_devicesArray)
    {
        _devicesArray = [NSMutableArray array];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [Post getDeviceInfoWithBlock:^(NSArray *deviceInfoArray) {
            [deviceInfoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DeviceInfoObj *deviceObj = [[DeviceInfoObj alloc]initWithDeviceAttribute:obj];
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
    MyDeviceCollectionViewCell *cell = (MyDeviceCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSString *imageName = [(DeviceInfoObj*)(self.devicesArray[indexPath.row]) getImageName];
    cell.image.image = [UIImage imageNamed:imageName];
    // Configure the cell
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return [CloudUtility isIphone6S] ? 50 : 30;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
