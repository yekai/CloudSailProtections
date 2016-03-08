//
//  WarningUnitViewController.m
//  CloudSailProtection
//
//  Created by Ice on 12/8/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "WarningUnitViewController.h"
#import "Post.h"
#import "MBProgressHUD.h"
#import "CSPLoginViewController.h"
#import "UIStoryBoard+New.h"
#import "CSPGlobalViewControlManager.h"

@interface WarningUnitViewController () <ChartViewDelegate>
@property (nonatomic, strong) IBOutlet PieChartView *chartView;
@property (nonatomic, strong) NSMutableArray *parties;
@end

@implementation WarningUnitViewController

- (void)closeSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//create pull request to load history alarm data
- (void)reloadAlarmNumberByLevel
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block WarningUnitViewController *weakSelf = self;
    [Post getAlarmNumberByTimeWithBlock:^(NSArray *alarmLevel) {
        [weakSelf createCircleChartWithArray:alarmLevel];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }
                         andFailureBlock:^{
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        CSPLoginViewController *login = [UIStoryboard instantiateControllerWithIdentifier:NSStringFromClass([CSPLoginViewController class])];
        [[[CSPGlobalViewControlManager sharedManager]rootCotrol]presentViewController:login animated:YES completion:nil];
    }];
}

//create circle chart for alarm level data
- (void)createCircleChartWithArray:(NSArray *)levelArray
{
    levelArray = [[[CSPGlobalViewControlManager sharedManager] getDefaultPageControl]getAlarmsInfo];
    
    _chartView.delegate = self;
    
    _chartView.usePercentValuesEnabled = NO;
    _chartView.holeTransparent = YES;
    _chartView.holeRadiusPercent = 0;
    _chartView.transparentCircleRadiusPercent = 1.0;
    _chartView.descriptionText = @"";
    [_chartView setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];
    
    _chartView.drawCenterTextEnabled = NO;
    
    _chartView.drawHoleEnabled = YES;
    _chartView.rotationAngle = 180.0;
    _chartView.rotationEnabled = YES;
    _chartView.highlightPerTapEnabled = YES;
    _chartView.backgroundColor = [UIColor clearColor];
    
    ChartLegend *l = _chartView.legend;
    l.position = ChartLegendPositionRightOfChart;
    l.xEntrySpace = 25.0;
    l.yEntrySpace = 5.0;
    l.yOffset = 10.0;
    l.xOffset = 25.0;
    l.font = [UIFont systemFontOfSize:12];
    
    
    NSMutableArray *levelNumber = [NSMutableArray arrayWithObjects:[NSNull null],[NSNull null],[NSNull null], nil];
    [levelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id number = levelNumber[[obj[@"alarmLevel"] integerValue] - 1];
        if (number != [NSNull null])
        {
            [levelNumber replaceObjectAtIndex:([obj[@"alarmLevel"] integerValue] - 1) withObject:@([obj[@"count"] integerValue] + [number integerValue])];
        }
        else
        {
            [levelNumber replaceObjectAtIndex:([obj[@"alarmLevel"] integerValue] - 1) withObject:@([obj[@"count"] integerValue])];
            [_parties addObject:[self getAlarmLevelNameByNumber:obj[@"alarmLevel"]]];
            
        }
    }];
    
    
    [levelNumber enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == [NSNull null])
        {
            [levelNumber removeObjectAtIndex:idx];
        }
    }];
    

    [self setData:levelNumber];
    
    [_chartView animateWithXAxisDuration:1.4 yAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
}

- (NSString *)getAlarmLevelNameByNumber:(NSString *)number
{
    if ([number integerValue] == 1)
    {
        return @"一级告警";
    }
    else if ([number integerValue] == 2)
    {
        return @"二级告警";
    }
    else if ([number integerValue] == 3)
    {
        return @"三级告警";
    }
    else if ([number integerValue] == 4)
    {
        return @"四级告警";
    }
    else if ([number integerValue] == 5)
    {
        return @"五级告警";
    }
    else if ([number integerValue] == 6)
    {
        return @"六级告警";
    }
    else if ([number integerValue] == 7)
    {
        return @"七级告警";
    }
    else if ([number integerValue] == 8)
    {
        return @"八级告警";
    }
    else if ([number integerValue] == 9)
    {
        return @"九级告警";
    }
    else if ([number integerValue] == 10)
    {
        return @"十级告警";
    }
    
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.title = @"告警统计";
    
    UIBarButtonItem *close = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(closeSelf)];
    self.navigationItem.rightBarButtonItems = @[close];

    _parties = [NSMutableArray array];
//    [self reloadAlarmNumberByLevel];
    [self createCircleChartWithArray:nil];
}

- (void)setData:(NSMutableArray *)levelNumbers
{
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
    for (int i = 0; i < levelNumbers.count; i++)
    {
        [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:[levelNumbers[i] doubleValue] xIndex:i]];
    }
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < levelNumbers.count; i++)
    {
        [xVals addObject:_parties[i % _parties.count]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals1 label:@""];
    dataSet.sliceSpace = 2.0;
    
    // add a lot of colors
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObject:[UIColor redColor]];
    [colors addObject:[UIColor blueColor]];
    [colors addObject:[UIColor greenColor]];
    [colors addObject:[UIColor grayColor]];
    [colors addObject:[UIColor orangeColor]];
    [colors addObject:[UIColor yellowColor]];
    [colors addObject:[UIColor cyanColor]];
    [colors addObject:[UIColor magentaColor]];
    [colors addObject:[UIColor purpleColor]];
    [colors addObject:[UIColor brownColor]];
    [colors addObject:[UIColor lightGrayColor]];
    [colors addObject:[UIColor lightTextColor]];
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithXVals:xVals dataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterNoStyle;
    pFormatter.maximumFractionDigits = 0;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:pFormatter];
    [data setValueFont:[UIFont systemFontOfSize:11]];
    [data setValueTextColor:UIColor.blackColor];
    
    _chartView.data = data;
    [_chartView highlightValues:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (void)displayHomeViewWithTabIndex:(NSInteger)index
{
    __weak CSPTransitionsViewController *transitionView = [[CSPGlobalViewControlManager sharedManager]getTransitionControl];

    [self dismissViewControllerAnimated:YES completion:^{
        [transitionView didSelectTabAtIndex:index];
    }];
}
@end
