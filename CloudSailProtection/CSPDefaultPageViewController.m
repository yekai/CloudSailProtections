//
//  CSPMyConcernViewController.m
//  CloudSailProtection
//
//  Created by Ice on 11/14/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "CSPDefaultPageViewController.h"
#import "TCircleView.h"
#import "UICountingLabel.h"
#import "CSPGlobalViewControlManager.h"
#import "Post.h"
#import "DefaultMainObj.h"
#import "MBProgressHUD.h"
#import "SessionManager.h"
#import "CloudUtility.h"
#import "HealthyCircleChartView.h"
#import "CSPLoginViewController.h"
#import "UIStoryBoard+New.h"
#import "CSPHeaderBar.h"
#import "CSPGlobalConstants.h"
#import "CSPGlobalViewControlManager.h"
#import "JSBadgeView.h"


@interface CSPDefaultPageViewController ()

//healthy background view
@property (weak, nonatomic) IBOutlet UIView *healthyBackView;
//healthy circle chart
@property (nonatomic, strong) HealthyCircleChartView *circleChart;
//healthy chart displaying counting number
@property (nonatomic, weak) IBOutlet UICountingLabel *countingLabel;
//breakdown chart
@property (nonatomic, strong) PNCloudeBarChart *trackBarChart;
//alarm chart
@property (nonatomic, strong) PNCloudeBarChart *warningBarChart;
//equipment warning bar chart
@property (nonatomic, strong) PNBarChart *equipmentWarningBarChart;
//not patrol breakdowns bar chart
@property (nonatomic, strong) PNBarChart *notPatrolBreakdownBarChart;
//the default dash model data
@property (nonatomic, strong) DefaultMainObj *mainAttributes;
//alarm and breakdown bar chart background view
@property (weak, nonatomic) IBOutlet UIView *barChartBackView;
@property (weak, nonatomic) IBOutlet UIView *trackChartBackView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *healthyBackBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *healthyWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warningChartWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trackChartWidthConstraint;

//alarm and breakdown button to display the data
@property (weak, nonatomic) IBOutlet UIButton *alarmCountBtn;
@property (weak, nonatomic) IBOutlet UIButton *trackCountBtn;


@end

@implementation CSPDefaultPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self commonInit];
    
    // Do any additional setup after loading the view.
}

//set charts background attributes
- (void)commonInit
{
    //healthy chart, alarm chart and breakdown chart corner radius and border
    CGColorRef borderColor = [UIColor colorWithRed:197/255.0 green:209/255.0 blue:214/255.0 alpha:1].CGColor;
    self.healthyBackView.layer.borderColor = borderColor;
    self.healthyBackView.layer.borderWidth = 1.0f;
    self.healthyBackView.layer.cornerRadius = 5.0;
    
    self.barChartBackView.layer.borderColor = borderColor;
    self.barChartBackView.layer.borderWidth = 1.0f;
    self.barChartBackView.layer.cornerRadius = 5.0;
    
    self.trackChartBackView.layer.borderColor = borderColor;
    self.trackChartBackView.layer.borderWidth = 1.0f;
    self.trackChartBackView.layer.cornerRadius = 5.0;
    
    self.healthyBackBottomConstraint.constant = [CloudUtility isIphone6S] ? 372 : 320;
    
    //display the number with ease in out animation kind
    _countingLabel.method = UILabelCountingMethodEaseInOut;

    CGFloat width = self.view.bounds.size.width - 20;
    self.healthyWidthConstraint.constant = width;
    
    //create healthy circle chart
    NSUInteger circleWH = [CloudUtility isIphone6S] ? 230 : 200;
    CGFloat originX = [CloudUtility isIphone6S] ? (self.view.bounds.size.width - circleWH - 20)/2 : (self.view.bounds.size.width - circleWH - 20)/2 - 10;
    self.circleChart = [HealthyCircleChartView loadCircleViewFromNibWithFrame:CGRectMake(originX, 10, circleWH, circleWH)];
    
    [self.healthyBackView insertSubview:self.circleChart atIndex:1];
    
    CGFloat warningTrackChartBackViewWith = (width - 10)/2;
    self.warningChartWidthConstraint.constant = warningTrackChartBackViewWith;
    self.trackChartWidthConstraint.constant = warningTrackChartBackViewWith;
}

//replace background while dismiss notice above
- (void)didSelectNoticeAtIndex:(NSUInteger)index
{
    [self.circleChart setShelterViewBackColor];
}

//make a pull request to fetch the default dash server data
- (void)reloadMainAttributes
{
    if (![[SessionManager sharedManager]isLoggedIn])
    {
        return;
    }
    
    __block CSPDefaultPageViewController *weakSelf = self;
    //show loading view
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //make pull request to get default dash data model
    [Post getDefaultPageAttributesWithBlock:^(NSDictionary *mainDict) {
        //create default dash data model from response json
        DefaultMainObj *obj = [[DefaultMainObj alloc]initWithMainDict:mainDict];
        weakSelf.mainAttributes = obj;
        //hide loading view
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        //create three parts charts
        [weakSelf createGraphicsFromAttributes];
    }
                            andFailureBlock:^{
        //display the login page if the server response fail
        CSPLoginViewController *login = [UIStoryboard instantiateControllerWithIdentifier:NSStringFromClass([CSPLoginViewController class])];
        [[[CSPGlobalViewControlManager sharedManager]rootCotrol]presentViewController:login animated:YES completion:nil];
    }];
}

- (void)createTabBarBadgeView
{
    if (self.trackBarChart || ![[SessionManager sharedManager]isLoggedIn])
    {
        return;
    }
    
    typeof(self) __weak weakSelf = self;
    CSPTransitionsViewController *transitionView = [[CSPGlobalViewControlManager sharedManager]getTransitionControl];
    NSMutableArray *tabBars = transitionView.tabs;
    [tabBars enumerateObjectsUsingBlock:^(__kindof AHTabView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if (idx == 1 && [weakSelf.mainAttributes.currentAlarm floatValue] != 0)
        {
            NSString *badgeText = [weakSelf.mainAttributes.currentAlarm floatValue] > 1000 ? @"..." : weakSelf.mainAttributes.currentAlarm;
            JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:obj.thumbnail alignment:JSBadgeViewAlignmentTopRight];
            badgeView.badgeText = badgeText;
        }
        else if (idx == 2 && [weakSelf.mainAttributes.currentFault floatValue] != 0)
        {
            NSString *badgeText = [weakSelf.mainAttributes.currentFault floatValue] > 1000 ? @"..." : weakSelf.mainAttributes.currentFault;
            JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:obj.thumbnail alignment:JSBadgeViewAlignmentTopRight];
            badgeView.badgeText = badgeText;
        }
    }];
}

//create healthy circle chart, alarm chart and breakdown chart
- (void)createGraphicsFromAttributes
{
    [self performSelector:@selector(createhealthyCircleChart) withObject:nil afterDelay:0.5];

    [self.alarmCountBtn setTitle:self.mainAttributes.currentAlarm forState:UIControlStateNormal];
    [self.alarmCountBtn setTitle:self.mainAttributes.currentAlarm forState:UIControlStateHighlighted];
    [self.trackCountBtn setTitle:self.mainAttributes.currentFault forState:UIControlStateNormal];
    [self.trackCountBtn setTitle:self.mainAttributes.currentFault forState:UIControlStateHighlighted];

    [self createTabBarBadgeView];
    [self createTrackBarChart];
    [self createWarningBarChart];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //reload default dash data
    [self reloadMainAttributes];
    //add pan gesture for default dash view
    if (self.slidingViewController.panGesture)
    {
        [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
    
    [self.view  updateConstraintsIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //remove pan gesture for default dash view
    if (self.slidingViewController.panGesture)
    {
        [self.view removeGestureRecognizer:self.slidingViewController.panGesture];
    }
}

//the root view for sliding control
- (ECSlidingViewController*)slidingViewController
{
    return [[CSPGlobalViewControlManager sharedManager]rootCotrol];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createhealthyCircleChart
{
    NSUInteger health = [self.mainAttributes.health integerValue];
    
    if (self.circleChart.circleChart.persentage > 0 || ![[SessionManager sharedManager]isLoggedIn])
    {
        return;
    }
    
    self.circleChart.circleChart.persentage = health / 100.0;
    [self.countingLabel countFromCurrentValueTo:health withDuration:1.0];
}

- (IBAction)OfficeHealthyButtonTapped:(id)sender
{
    //hide the tap action on healthy circle chart
    return;
    
    BOOL isHidden =  self.barChartBackView.superview.hidden;
    BOOL isIphone6S = [CloudUtility isIphone6S];
    [self.circleChart toggleShelterViewBackColor];
    if (isHidden)
    {
        self.healthyBackBottomConstraint.constant = isIphone6S ? 372 : 320;
    }
    else
    {
        self.healthyBackBottomConstraint.constant = 85;
        [self createEquipmentWarningBarChart];
        [self createNotPatrolBreakdownBarChart];
    }
    self.barChartBackView.superview.hidden = !isHidden;
    
}

- (void)createTrackBarChart
{
    if (![[SessionManager sharedManager]isLoggedIn] || !self.mainAttributes.faultInfos)
    {
        return;
    }
    
    if (self.trackBarChart)
    {
        [self.trackBarChart removeFromSuperview];
    }
    
    static NSNumberFormatter *barChartFormatter;
    if (!barChartFormatter){
        barChartFormatter = [[NSNumberFormatter alloc] init];
        barChartFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        barChartFormatter.allowsFloats = NO;
        barChartFormatter.maximumFractionDigits = 0;
    }
 
    NSMutableArray *numbers = [NSMutableArray array];
    NSMutableArray *xStatus = [NSMutableArray array];
    NSMutableArray *backColors = [NSMutableArray array];
    UIColor *blueColor = [UIColor colorWithRed:102/255.0 green:192/255.0 blue:251/255.0 alpha:1];

    [self.mainAttributes.faultInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [numbers addObject:@([obj[@"count"] integerValue])];
        [xStatus addObject:obj[@"statusName"] ];
        [backColors addObject:blueColor];
    }];
    
    __block NSInteger maxY = [numbers[0] integerValue];
    
    [numbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj integerValue] > maxY)
        {
            maxY = [obj integerValue];
        }
    }];

    
    self.trackBarChart = [[PNCloudeBarChart alloc] initWithFrame:CGRectMake(0, 78.0, self.trackChartBackView.bounds.size.width, self.trackChartBackView.bounds.size.height - 80)];
    self.trackBarChart.backgroundColor = [UIColor clearColor];
    self.trackBarChart.yLabelFormatter = ^(CGFloat yValue){
        return [barChartFormatter stringFromNumber:[NSNumber numberWithFloat:yValue]];
    };
    
    self.trackBarChart.labelFont = [UIFont systemFontOfSize:9];
    self.trackBarChart.yChartLabelWidth = 40.0;
    self.trackBarChart.chartMarginLeft = 30.0;
    self.trackBarChart.chartMarginRight = 10.0;
    self.trackBarChart.chartMarginTop = 0.0;
    self.trackBarChart.chartMarginBottom = 0.0;
    self.trackBarChart.labelMarginTop = 10;
    self.trackBarChart.yLabelSum = 3;
    self.trackBarChart.xLabelWidth = 10.0;
    self.trackBarChart.barWidth = 20;
    self.trackBarChart.chartMarginTop = 0;
    self.trackBarChart.barBackgroundColor = [UIColor clearColor];
    
    
    self.trackBarChart.labelMarginTop = 0.0;
    self.trackBarChart.labelTextColor = blueColor;
    self.trackBarChart.showChartBorder = YES;
    [self.trackBarChart setXLabels:xStatus];
    [self.trackBarChart setYMaxValue:maxY + 50];
    [self.trackBarChart setYValues:numbers];
    [self.trackBarChart setStrokeColors:backColors];
    self.trackBarChart.isGradientShow = NO;
    self.trackBarChart.isShowNumbers = YES;
    
    [self.trackBarChart strokeChart];
    
    self.trackBarChart.delegate = self;
    self.trackBarChart.userInteractionEnabled = YES;
    
    [self.trackChartBackView addSubview:self.trackBarChart];

}

- (NSArray *)getAlarmsInfo
{
    return self.mainAttributes.alarmInfos;
}

- (void)createWarningBarChart
{
    
    if (![[SessionManager sharedManager]isLoggedIn] || !self.mainAttributes.alarmInfos)
    {
        return;
    }
    
    if(self.warningBarChart)
    {
        [self.warningBarChart removeFromSuperview];
    }
    
    static NSNumberFormatter *barChartFormatter;
    if (!barChartFormatter){
        barChartFormatter = [[NSNumberFormatter alloc] init];
        barChartFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        barChartFormatter.allowsFloats = NO;
        barChartFormatter.maximumFractionDigits = 0;
    }
    
    NSMutableArray *numbers = [NSMutableArray arrayWithObjects:[NSNull null],[NSNull null],[NSNull null], nil];
    NSMutableArray *xStatus = [NSMutableArray arrayWithObjects:[NSNull null],[NSNull null],[NSNull null], nil];
    NSMutableArray *backColors = [NSMutableArray array];
    UIColor *blueColor = [UIColor colorWithRed:102/255.0 green:192/255.0 blue:251/255.0 alpha:1];
    [self.mainAttributes.alarmInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id number = numbers[[obj[@"alarmLevel"] integerValue] - 1];
        if (number != [NSNull null])
        {
            [numbers replaceObjectAtIndex:([obj[@"alarmLevel"] integerValue] - 1) withObject:@([obj[@"count"] integerValue] + [number integerValue])];
        }
        else
        {
            [numbers replaceObjectAtIndex:([obj[@"alarmLevel"] integerValue] - 1) withObject:@([obj[@"count"] integerValue])];
            [xStatus replaceObjectAtIndex:([obj[@"alarmLevel"] integerValue] - 1) withObject:obj[@"alarmLevelName"]];
            [backColors addObject:blueColor];

        }
    }];
    
    [numbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == [NSNull null])
        {
            [numbers removeObjectAtIndex:idx];
        }
    }];
    
    [xStatus enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == [NSNull null])
        {
            [xStatus removeObjectAtIndex:idx];
        }
    }];
    
    __block NSInteger maxY = [numbers[0] integerValue];
    
    [numbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != [NSNull null] && [obj integerValue] > maxY)
        {
            maxY = [obj integerValue];
        }
    }];
    
    
    self.warningBarChart = [[PNCloudeBarChart alloc] initWithFrame:CGRectMake(0, 78.0, self.trackChartBackView.bounds.size.width, self.trackChartBackView.bounds.size.height - 80)];
    self.warningBarChart.backgroundColor = [UIColor clearColor];
    self.warningBarChart.yLabelFormatter = ^(CGFloat yValue){
        return [barChartFormatter stringFromNumber:[NSNumber numberWithFloat:yValue]];
    };
    
    self.warningBarChart.labelFont = [UIFont systemFontOfSize:9];
    self.warningBarChart.yChartLabelWidth = 40.0;
    self.warningBarChart.chartMarginLeft = 30.0;
    self.warningBarChart.chartMarginRight = 10.0;
    self.warningBarChart.chartMarginTop = 0.0;
    self.warningBarChart.chartMarginBottom = 0.0;
    self.warningBarChart.labelMarginTop = 10;
    self.warningBarChart.yLabelSum = 3;
    self.warningBarChart.xLabelWidth = 10.0;
    self.warningBarChart.barWidth = 20;
    self.warningBarChart.barBackgroundColor = [UIColor clearColor];
    
    
    self.warningBarChart.labelMarginTop = 0.0;
    self.warningBarChart.labelTextColor = blueColor;
    self.warningBarChart.showChartBorder = YES;
    [self.warningBarChart setXLabels:xStatus];
    [self.warningBarChart setYMaxValue:maxY + 7000];
    [self.warningBarChart setYValues:numbers];
    [self.warningBarChart setStrokeColors:backColors];
    self.warningBarChart.isGradientShow = NO;
    self.warningBarChart.isShowNumbers = YES;
    
    [self.warningBarChart strokeChart];
    
    self.warningBarChart.delegate = self;
    self.warningBarChart.userInteractionEnabled = YES;
    [self.barChartBackView addSubview:self.warningBarChart];

}

- (void)createEquipmentWarningBarChart
{
    if (![[SessionManager sharedManager]isLoggedIn] || self.equipmentWarningBarChart)
    {
        return;
    }
    
    static NSNumberFormatter *barChartFormatter;
    if (!barChartFormatter){
        barChartFormatter = [[NSNumberFormatter alloc] init];
        barChartFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        barChartFormatter.allowsFloats = NO;
        barChartFormatter.maximumFractionDigits = 0;
    }
    
    NSUInteger trackHeight = [CloudUtility isIphone6S] ? 280 : 250;
    NSUInteger trackY = [CloudUtility isIphone6S] ? 248 : 228;
    
    self.equipmentWarningBarChart = [[PNBarChart alloc] initWithFrame:CGRectMake(30, trackY, self.healthyBackView.bounds.size.width/2 - 20, trackHeight)];
    self.equipmentWarningBarChart.showLabel = NO;
    self.equipmentWarningBarChart.labelTextFontSize = 15;
    self.equipmentWarningBarChart.barRadius = 5.0f;
    self.equipmentWarningBarChart.backgroundColor = [UIColor clearColor];
    self.equipmentWarningBarChart.yLabelFormatter = ^(CGFloat yValue){
        return [barChartFormatter stringFromNumber:[NSNumber numberWithFloat:yValue]];
    };
    
    self.equipmentWarningBarChart.xLabelWidth = 5.0;
    self.equipmentWarningBarChart.barWidth = 40.0;
    self.equipmentWarningBarChart.isGradientShow = NO;
    self.equipmentWarningBarChart.isShowNumbers = NO;
    
    self.equipmentWarningBarChart.labelMarginTop = 5.0;
    self.equipmentWarningBarChart.showChartBorder = NO;
    self.equipmentWarningBarChart.labelTextColor = [UIColor whiteColor];
    [self.equipmentWarningBarChart setXLabels:@[@"4",@"5"]];
    [self.equipmentWarningBarChart setYValues:@[@0.3,@0.5]];
    [self.equipmentWarningBarChart setDisplayTexts:@[@"机\n柜\n容\n量",@"告\n警"]];
    UIColor *blue = [UIColor colorWithRed:72/255.0 green:170/255.0 blue:250/255.0 alpha:1];
    [self.equipmentWarningBarChart setStrokeColors:@[blue,blue]];
    
    [self.equipmentWarningBarChart strokeChart];
    
    self.equipmentWarningBarChart.delegate = self;
    
    [self.healthyBackView addSubview:self.equipmentWarningBarChart];
    
}


- (void)createNotPatrolBreakdownBarChart
{
    if (self.notPatrolBreakdownBarChart || ![[SessionManager sharedManager]isLoggedIn])
    {
        return;
    }
    
    static NSNumberFormatter *barChartFormatter;
    if (!barChartFormatter){
        barChartFormatter = [[NSNumberFormatter alloc] init];
        barChartFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        barChartFormatter.allowsFloats = NO;
        barChartFormatter.maximumFractionDigits = 0;
    }
    
    
    NSUInteger trackHeight = [CloudUtility isIphone6S] ? 280 : 250;
    NSUInteger trackY = [CloudUtility isIphone6S] ? 248 : 228;
    self.notPatrolBreakdownBarChart = [[PNBarChart alloc] initWithFrame:CGRectMake(self.healthyBackView.bounds.size.width/2 - 9, trackY, self.healthyBackView.bounds.size.width/2 - 20, trackHeight)];
    self.notPatrolBreakdownBarChart.showLabel = NO;
    self.notPatrolBreakdownBarChart.labelTextFontSize = 15;
    self.notPatrolBreakdownBarChart.barRadius = 5.0f;
    self.notPatrolBreakdownBarChart.backgroundColor = [UIColor clearColor];
    self.notPatrolBreakdownBarChart.yLabelFormatter = ^(CGFloat yValue){
        return [barChartFormatter stringFromNumber:[NSNumber numberWithFloat:yValue]];
    };
    
    self.notPatrolBreakdownBarChart.xLabelWidth = 5.0;
    self.notPatrolBreakdownBarChart.barWidth = 40.0;
    self.notPatrolBreakdownBarChart.isGradientShow = NO;
    self.notPatrolBreakdownBarChart.isShowNumbers = NO;
    
    self.notPatrolBreakdownBarChart.labelMarginTop = 5.0;
    self.notPatrolBreakdownBarChart.showChartBorder = NO;
    self.notPatrolBreakdownBarChart.labelTextColor = [UIColor whiteColor];
    [self.notPatrolBreakdownBarChart setXLabels:@[@"4",@"5"]];
    [self.notPatrolBreakdownBarChart setYValues:@[@0.7,@0.6]];
    [self.notPatrolBreakdownBarChart setDisplayTexts:@[@"未\n完\n巡\n检",@"故\n障"]];
    UIColor *blue = [UIColor colorWithRed:72/255.0 green:170/255.0 blue:250/255.0 alpha:1];
    [self.notPatrolBreakdownBarChart setStrokeColors:@[blue,blue]];
    
    [self.notPatrolBreakdownBarChart strokeChart];
    
    self.notPatrolBreakdownBarChart.delegate = self;
    
    [self.healthyBackView addSubview:self.notPatrolBreakdownBarChart];
    
}

- (IBAction)warningOrTrackBtnTapped:(id)sender
{
    NSInteger tag = ((UIButton*)sender).tag - kCSP_DefaultBtn_Tag + 1;
    [[[CSPGlobalViewControlManager sharedManager]getTransitionControl]didSelectTabAtIndex:tag];
}


- (void)userClickedOnLineKeyPoint:(CGPoint)point
                        lineIndex:(NSInteger)lineIndex
                       pointIndex:(NSInteger)pointIndex
                        lineChart:(UIView *)lineChart
{
    if (lineChart == self.warningBarChart)
    {
        self.warningChartWidthConstraint.constant = self.warningChartWidthConstraint.constant * 2 + 10;
        self.trackChartWidthConstraint.constant = 0;
    }
    else if (lineChart == self.trackBarChart)
    {
        self.trackChartWidthConstraint.constant = self.trackChartWidthConstraint.constant * 2 + 10;
        self.warningChartWidthConstraint.constant = 0;
    }
}

- (NSArray *)tabBarStatesForCurrentApps
{
    typeof(self) __weak weakSelf = self;
    __block NSMutableArray *statesArray = [NSMutableArray arrayWithArray:@[@"-1",@"-1",@"-1"]];
    CSPTransitionsViewController *transitionView = [[CSPGlobalViewControlManager sharedManager]getTransitionControl];
    NSMutableArray *tabBars = transitionView.tabs;
    [tabBars enumerateObjectsUsingBlock:^(__kindof AHTabView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if (idx == 1 && [obj.thumbnail.subviews count] > 0)
         {
             NSString *badgeText = [weakSelf.mainAttributes.currentAlarm floatValue] > 1000 ? @"..." : weakSelf.mainAttributes.currentAlarm;
             [statesArray replaceObjectAtIndex:0 withObject:badgeText];
         }
         else if (idx == 2)
         {
             if ([weakSelf.mainAttributes.currentFault floatValue] != 0.0)
             {
                 NSString *badgeText = [weakSelf.mainAttributes.currentFault floatValue] > 1000 ? @"..." : weakSelf.mainAttributes.currentFault;
                 [statesArray replaceObjectAtIndex:1 withObject:badgeText];
             }
         }
         
         if ([obj isSelected])
         {
             [statesArray replaceObjectAtIndex:2 withObject:@(idx)];
         }
     }];
    
    return statesArray;
}
@end
