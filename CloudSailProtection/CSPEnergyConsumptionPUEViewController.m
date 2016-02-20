//
//  CSPEnergyConsumptionPUEViewController.m
//  CloudSailProtection
//
//  Created by Ice on 12/12/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "CSPEnergyConsumptionPUEViewController.h"
#import "WMGaugeView.h"
#import "CloudUtility.h"
#import "Post.h"
#import "MBProgressHUD.h"
#import "CSPEnergyConsumptionViewController.h"
#import "UIStoryBoard+New.h"
#import "CSPLoginViewController.h"
#import "CSPGlobalViewControlManager.h"

@interface CSPEnergyConsumptionPUEViewController ()
@property (weak, nonatomic) IBOutlet WMGaugeView *gaugeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gaugeViewHeightConstraint;

@end

@implementation CSPEnergyConsumptionPUEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createGaugeViewWithPUEData];
    [self reloadPUEData];
    
    self.title = @"能耗";
    
    UIBarButtonItem *close = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeSelf)];
    
    self.navigationItem.rightBarButtonItems = @[close];
}

- (void)closeSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadPUEData
{
    __block CSPEnergyConsumptionPUEViewController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [Post getPUEDataWithBlock:^(CGFloat pueData) {
        [weakSelf setGaugeViewValue:@(pueData)];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } andFailureBlock:^{
        CSPLoginViewController *login = [UIStoryboard instantiateControllerWithIdentifier:NSStringFromClass([CSPLoginViewController class])];
        [[[CSPGlobalViewControlManager sharedManager]rootCotrol]presentViewController:login animated:YES completion:nil];
    }];
    
}

- (void)createGaugeViewWithPUEData
{
    self.gaugeViewHeightConstraint.constant = [CloudUtility isIphone6S] ? 300 : 260;
    
    _gaugeView.style = [WMGaugeViewStyle3D new];
    _gaugeView.maxValue = 4.0;
    _gaugeView.minValue = 0;
    _gaugeView.showRangeLabels = YES;
    _gaugeView.rangeValues = @[@1,@2,@3.0,@4.0];
    _gaugeView.rangeColors = @[RGB(27, 202, 33),RGB(232, 231, 33),RGB(232, 111, 33),RGB(231, 32, 43)];
    _gaugeView.rangeLabels = @[@"低",@"正常",@"高",@"很高"];
    _gaugeView.unitOfMeasurement = [NSString stringWithFormat:@"园区PUE:%.3f",0.00] ;
    _gaugeView.unitOfMeasurementColor = [UIColor blackColor];
    _gaugeView.showUnitOfMeasurement = YES;
    _gaugeView.showInnerBackground = NO;
    _gaugeView.scaleDivisions = 4.0;
    _gaugeView.scaleDivisionsWidth = 0.0008;
    _gaugeView.scaleSubdivisionsWidth = 0.0006;
    _gaugeView.scaleSubdivisions = 1;
    _gaugeView.rangeLabelsFontColor = [UIColor whiteColor];
    _gaugeView.rangeLabelsWidth = 0.10;
    _gaugeView.rangeLabelsFont = [UIFont fontWithName:@"Helvetica" size:0.04];
    _gaugeView.value = 0;
    
}

- (void)setGaugeViewValue:(NSNumber *)number
{
    _gaugeView.value = [number floatValue];
    _gaugeView.unitOfMeasurement = [NSString stringWithFormat:@"园区PUE:%.3f",[number floatValue]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)presentEnergyConsumptionView
{
    CSPEnergyConsumptionViewController *control = [UIStoryboard instantiateControllerWithIdentifier:NSStringFromClass(CSPEnergyConsumptionViewController.class)];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:control];
    [self presentViewController:navi animated:YES completion:nil];
}

@end
