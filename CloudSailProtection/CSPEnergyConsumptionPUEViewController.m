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
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *itConsumption;
@property (weak, nonatomic) IBOutlet UILabel *totalConsumption;
@property (weak, nonatomic) IBOutlet UIView *itTotalConsumptionSuperView;

@end

@implementation CSPEnergyConsumptionPUEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title = @"能耗";
    
    UIBarButtonItem *close = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(closeSelf)];
    
    self.navigationItem.rightBarButtonItems = @[close];
    
    self.itTotalConsumptionSuperView.layer.cornerRadius = 10.0;
    [self createGaugeViewWithPUEData];
}


- (void)closeSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadPUEData
{
    __block CSPEnergyConsumptionPUEViewController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [Post getPUEDataWithBlock:^(NSDictionary *pueData) {
        NSNumber *pueValue = @([pueData[@"puevalue"] floatValue]);
        NSString *itEnergy = [NSString stringWithFormat:@"%.0f", [pueData[@"itEnergy"] floatValue]];
        NSString *totalEnergy = [NSString stringWithFormat:@"%.0f", [pueData[@"totalEnergy"] floatValue]];
        [weakSelf setGaugeViewValue:pueValue];
        [weakSelf setItEnergyValue:itEnergy andTotalEnergyValue:totalEnergy];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } andFailureBlock:^{
        CSPLoginViewController *login = [UIStoryboard instantiateControllerWithIdentifier:NSStringFromClass([CSPLoginViewController class])];
        [[[CSPGlobalViewControlManager sharedManager]rootCotrol]presentViewController:login animated:YES completion:nil];
    }];
    
}

- (void)createGaugeViewWithPUEData
{
    self.itTotalConsumptionSuperView.hidden = YES;
    self.gaugeViewHeightConstraint.constant = [CloudUtility isIphone6S] ? 300 : 260;
    
    _gaugeView.style = [WMGaugeViewStyle3D new];
    _gaugeView.maxValue = 4.0;
    _gaugeView.minValue = 0;
    _gaugeView.showRangeLabels = YES;
    _gaugeView.rangeValues = @[@1,@2,@3.0,@4.0];
    _gaugeView.rangeColors = @[RGB(27, 202, 33),RGB(232, 231, 33),RGB(232, 111, 33),RGB(231, 32, 43)];
    _gaugeView.rangeLabels = @[@"低",@"正常",@"高",@"很高"];
    _gaugeView.unitOfMeasurement = [NSString stringWithFormat:@"实时PUE:%.1f",0.00] ;
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
    
    _backButton.backgroundColor = [UIColor colorWithRed:204/255.0 green:227/255.0 blue:241/255.0 alpha:1];
    _backButton.layer.cornerRadius = 20;
    [self.view sendSubviewToBack:_backButton];
    
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentEnergyConsumptionView)];
    singleRecognizer.numberOfTapsRequired = 1; 
    
    [_gaugeView addGestureRecognizer:singleRecognizer];
    
}

- (void)setGaugeViewValue:(NSNumber *)number
{
    _gaugeView.value = [number floatValue];
    _gaugeView.unitOfMeasurement = [NSString stringWithFormat:@"实时PUE:%.1f",[number floatValue]];
}

- (void)setItEnergyValue:(NSString *)itEnergy andTotalEnergyValue:(NSString *)totalEnergy
{
    self.itTotalConsumptionSuperView.hidden = NO;
    self.itConsumption.text = [NSString stringWithFormat:@"IT能耗:%@", itEnergy];
    self.totalConsumption.text = [NSString stringWithFormat:@"总能耗:%@", totalEnergy];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadPUEData];
}

- (IBAction)presentEnergyConsumptionView
{
    CSPEnergyConsumptionViewController *control = [UIStoryboard instantiateControllerWithIdentifier:NSStringFromClass(CSPEnergyConsumptionViewController.class)];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:control];
    [self presentViewController:navi animated:YES completion:nil];
}

@end
