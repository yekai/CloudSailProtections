//
//  HealthyCircleChartView.h
//  CloudSailProtection
//
//  Created by Ice on 12/27/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCircleView;
@class UICountingLabel;

@interface HealthyCircleChartView : UIView

@property (nonatomic, weak) IBOutlet TCircleView *circleChart;
@property (weak, nonatomic) IBOutlet UIView *shelterView;

+ (HealthyCircleChartView *)loadCircleViewFromNibWithFrame:(CGRect)frame;
- (void)toggleShelterViewBackColor;
- (void)setShelterViewBackColor;
@end
