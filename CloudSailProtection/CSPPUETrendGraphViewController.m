//
//  CSPPUETrendGraphViewController.m
//  CloudSailProtection
//
//  Created by Ice on 12/2/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "CSPPUETrendGraphViewController.h"
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"
#import "CloudUtility.h"
#import "Post.h"
#import "MBProgressHUD.h"
#import "CSPLoginViewController.h"
#import "CSPGlobalViewControlManager.h"
#import "UIStoryBoard+New.h"

@interface CSPPUETrendGraphViewController ()
@property (weak, nonatomic) IBOutlet UIView *trendGraphBack;
@property (weak, nonatomic) IBOutlet UISegmentedControl *graphTypeSegment;
@property (nonatomic, strong) FSLineChart *lineChart;
@end

@implementation CSPPUETrendGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL isFromEnergyConsumption = self.navigationController.viewControllers.count > 1;
    self.title = isFromEnergyConsumption ? @"能耗" : @"故障";
    if (!isFromEnergyConsumption)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(closeSelf)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"数据报表" style:UIBarButtonItemStylePlain target:self action:@selector(popout)];
    }
}

- (void)popout
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadFaultNumHisData];
}

- (void)reloadFaultNumHisData
{
    NSString *type = self.graphTypeSegment.selectedSegmentIndex == 0 ? @"Day" : self.graphTypeSegment.selectedSegmentIndex == 1 ? @"Mon" : @"Yea";
    __weak CSPPUETrendGraphViewController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Post getFaultNumByTimeWithType:type
                       successBlock:^(NSArray *routinsArray)
    {
        [weakSelf createGraph:routinsArray];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }andFailureBlock:^{
        CSPLoginViewController *login = [UIStoryboard instantiateControllerWithIdentifier:NSStringFromClass([CSPLoginViewController class])];
        [[[CSPGlobalViewControlManager sharedManager]rootCotrol]presentViewController:login animated:YES completion:nil];
    }];
}

- (IBAction)graphSegmentValueChanged:(id)sender
{
    [self.lineChart removeFromSuperview];
    self.lineChart = nil;
    [self reloadFaultNumHisData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createGraph:(NSArray *)routinsArray
{
    if (self.lineChart)
    {
        return;
    }
    
    NSUInteger widthSpace = self.graphTypeSegment.bounds.size.width * 2 + ([CloudUtility isIphone6S] ? 110 : 40);
    
    NSUInteger height = [CloudUtility isIphone6S] ? 460 : 420;
    // Creating the line chart
    FSLineChart* lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(30, 135, self.trendGraphBack.bounds.size.width - widthSpace, height)];
    lineChart.lineWidth = 1;
    lineChart.color = lineChart.fillColor;
    lineChart.verticalGridStep = 5;
    lineChart.horizontalGridStep = 4;
    lineChart.displayDataPoint = NO;
    lineChart.valueLabelPosition = ValueLabelLeft;
    lineChart.drawInnerGrid = YES;
    lineChart.bezierSmoothing = YES;
    lineChart.axisColor = [UIColor blueColor];
    lineChart.innerGridColor = [UIColor blueColor];
    lineChart.innerGridLineWidth = 1.0;
    lineChart.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *Xvalues = [NSMutableArray array];
    NSMutableArray *chartDataArray = [NSMutableArray array];
    
    [routinsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *time = obj[@"time"];
        if ([Xvalues containsObject:time])
        {
            NSInteger index = [Xvalues indexOfObject:time];
            [chartDataArray replaceObjectAtIndex:index withObject:@([chartDataArray[index] integerValue] + [obj[@"count"] integerValue])];
        }
        else
        {
            [Xvalues addObject:obj[@"time"]];
            [chartDataArray addObject:@([obj[@"count"] integerValue])];
        }
    }];
    
    
    lineChart.labelForIndex = ^(NSUInteger item) {
        return Xvalues[item];
    };
    
    lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.f", value];
    };
    
    [lineChart setChartData:chartDataArray];
    self.lineChart = lineChart;
    [self.view addSubview:self.lineChart];
    
    UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(35, 135, 1, height)];
    verticalLine.backgroundColor = lineChart.fillColor;
    [self.view addSubview:verticalLine];
    
    UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(35, 130 + height , CGRectGetWidth(self.lineChart.bounds), 1)];
    horizontalLine.backgroundColor = lineChart.fillColor;
    [self.view addSubview:horizontalLine];
}


- (void)displayHomeViewWithTabIndex:(NSInteger)index
{
    __weak CSPTransitionsViewController *transitionView = [[CSPGlobalViewControlManager sharedManager]getTransitionControl];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [transitionView didSelectTabAtIndex:index];
    }];
}
@end
