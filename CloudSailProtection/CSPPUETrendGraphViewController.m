//
//  CSPPUETrendGraphViewController.m
//  CloudSailProtection
//
//  Created by Ice on 12/2/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "CSPPUETrendGraphViewController.h"
#import "UIColor+FSPalette.h"
#import "CloudUtility.h"
#import "Post.h"
#import "MBProgressHUD.h"
#import "CSPLoginViewController.h"
#import "CSPGlobalViewControlManager.h"
#import "UIStoryBoard+New.h"


@import Charts;
@interface CSPPUETrendGraphViewController () <ChartViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *trendGraphBack;
@property (weak, nonatomic) IBOutlet UISegmentedControl *graphTypeSegment;
@property (nonatomic, strong) IBOutlet LineChartView *chartView;
@property (nonatomic, assign) CGRect frame;
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
    [self.chartView removeFromSuperview];
    self.chartView = nil;
    
    [self reloadFaultNumHisData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createGraph:(NSArray *)routinsArray
{
    if (CGRectIsEmpty(self.frame))
    {
        self.frame = _chartView.frame;
    }
    
    self.chartView = [[LineChartView alloc]initWithFrame:self.frame];
    [_trendGraphBack addSubview:self.chartView];
    _chartView.delegate = self;
    _chartView.backgroundColor = [UIColor clearColor];
    
    _chartView.descriptionText = @"";
    _chartView.noDataTextDescription = @"You need to provide data for the chart.";
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = NO;
    _chartView.drawGridBackgroundEnabled = YES;
    _chartView.xAxis.labelTextColor = [UIColor darkGrayColor];
    _chartView.leftAxis.labelTextColor = [UIColor darkGrayColor];
    _chartView.xAxis.labelPosition = XAxisLabelPositionBottom;
//    _chartView.xAxis.labelFont = [UIFont systemFontOfSize:8];
    [_chartView.xAxis setLabelsToSkip:0];
    _chartView.borderColor = [UIColor grayColor];
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.startAtZeroEnabled = YES;
    leftAxis.gridLineDashLengths = @[@100.f, @0.f];
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    _chartView.rightAxis.enabled = NO;
    
    [_chartView.viewPortHandler setMaximumScaleY: 2.f];
    [_chartView.viewPortHandler setMaximumScaleX: 2.f];
    
    
    _chartView.legend.form = ChartLegendFormLine;
    
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
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < Xvalues.count; i++)
    {
        [xVals addObject:Xvalues[i]];
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    NSInteger maxY = 0;
    NSInteger minY = [chartDataArray[0] integerValue];
    for (NSInteger i = 0; i < Xvalues.count; i++)
    {
        NSInteger value = [chartDataArray[i] integerValue];
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:value xIndex:i]];
        if (value > maxY)
        {
            maxY = value;
        }
        
        if (value < minY)
        {
            minY = value;
        }
    }
    
    if (maxY < 10)
    {
        maxY += 0;
    }
    else if (maxY < 50)
    {
        maxY += 5;
    }
    else if(maxY < 100)
    {
        maxY += 10;
    }
    else
    {
        maxY += 15;
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@""];
    
    set1.lineDashLengths = @[@100.f, @0.f];
    set1.highlightLineDashLengths = @[@100.f, @0.f];
    [set1 setColor:UIColor.redColor];
    [set1 setCircleColor:UIColor.orangeColor];
    set1.lineWidth = 1.0;
    set1.circleRadius = 10.0;
    set1.drawCircleHoleEnabled = YES;
    set1.drawCubicEnabled = NO;
    set1.valueFont = [UIFont systemFontOfSize:9.f];
    set1.valueTextColor = [UIColor orangeColor];
    set1.fillAlpha = 65/255.0;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    _chartView.leftAxis.customAxisMax = maxY;
    _chartView.leftAxis.customAxisMin = minY;
    _chartView.data = data;
    [_chartView animateWithXAxisDuration:1.0 yAxisDuration:1.0];
}


- (void)displayHomeViewWithTabIndex:(NSInteger)index
{
    __weak CSPTransitionsViewController *transitionView = [[CSPGlobalViewControlManager sharedManager]getTransitionControl];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [transitionView didSelectTabAtIndex:index];
    }];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}
@end
