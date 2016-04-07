//
//  DefaultMainObj.h
//  CloudSailProtection
//
//  Created by Ice on 12/24/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DefaultMainObj : NSObject

@property (nonatomic, copy) NSString *health;
@property (nonatomic, copy) NSString *currentAlarm;
@property (nonatomic, copy) NSString *currentFault;
@property (nonatomic, copy) NSString *beatNumbers;
@property (nonatomic, strong) NSMutableArray *alarmInfos;
@property (nonatomic, strong) NSMutableArray *faultInfos;

- (instancetype)initWithMainDict:(NSDictionary *)main;
- (NSArray *)faultsXstatus;
- (NSMutableArray *)alarmsXStatus;
- (UIColor *)chartColorForDefaultPage;
- (NSMutableArray *)faultsNumberArray;
- (NSMutableArray *)alarmsNumberArray;
- (NSUInteger)maxFaultsNumber;
- (NSUInteger)maxAlarmsNumber;
- (NSMutableArray *)alarmsChartColors;
@end
