//
//  HealthyCircleChartView.m
//  CloudSailProtection
//
//  Created by Ice on 12/27/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "HealthyCircleChartView.h"
#import "TCircleView.h"
#import "UICountingLabel.h"
#import "CloudUtility.h"
#import "CSPHeaderBar.h"

@implementation HealthyCircleChartView

+ (HealthyCircleChartView *)loadCircleViewFromNibWithFrame:(CGRect)frame
{
    HealthyCircleChartView *circleView = (HealthyCircleChartView *)([[NSBundle mainBundle] loadNibNamed:@"HealthyCircleChart" owner:nil options:nil][0]);
    circleView.frame = frame;
    
    [circleView.circleChart setupCircleView];
    circleView.circleChart.persentage = 0;
    
    return circleView;
}

- (void)setShelterViewBackColor
{
    if (![self.shelterView.backgroundColor isEqual: [UIColor whiteColor]])
    {
        self.shelterView.backgroundColor = [UIColor colorWithRed:249/255.0 green:251/255.0 blue:252/255.0 alpha:1];
    }
}

- (void)toggleShelterViewBackColor
{
    if ([self.shelterView.backgroundColor isEqual: [UIColor whiteColor]])
    {
        self.shelterView.backgroundColor = [CSPHeaderBar isDefaultPageNoticeDismiss] ? [UIColor colorWithRed:249/255.0 green:251/255.0 blue:252/255.0 alpha:1] : [UIColor colorWithRed:233/255.0 green:240/255.0 blue:245/255.0 alpha:1];
    }
    else
    {
        self.shelterView.backgroundColor = [ UIColor whiteColor];
    }
}
@end
