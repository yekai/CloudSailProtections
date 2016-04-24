//
//  DefaultMainObj.m
//  CloudSailProtection
//
//  Created by Ice on 12/24/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "DefaultMainObj.h"

@implementation DefaultMainObj

- (instancetype)initWithMainDict:(NSDictionary *)main
{
    if (self = [super init])
    {
        self.health = main[@"health"];
        self.currentAlarm = [main[@"currentAlarm"] stringValue];
        self.currentFault = [main[@"currentFault"] stringValue];
        
        self.alarmInfos = main[@"alarmNum"];
        self.faultInfos = main[@"faultNum"];
        
        self.beatNumbers = [main[@"beatnumber"] stringValue];
    }
    
    return self;
}

- (NSString *)currentAlarm
{
    if ([self.alarmInfos isEqual:[NSNull null]])
    {
        return 0;
    }
    NSMutableArray *numbers = [NSMutableArray array];
    [self.alarmInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [numbers addObject:@([obj[@"count"] integerValue])];
    }];
    
    __block NSInteger count = 0;
    
    [numbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        count += [obj integerValue];
    }];
    
    return [@(count) stringValue];
}

- (NSString *)currentFault
{
    if ([self.faultInfos isEqual:[NSNull null]])
    {
        return 0;
    }
    NSMutableArray *numbers = [NSMutableArray array];
    [self.faultInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj[@"statusName"] isEqualToString:@"故障关闭"])
        {
            [numbers addObject:@([obj[@"count"] integerValue])];
        }
    }];
    
    __block NSInteger count = 0;
    
    [numbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        count += [obj integerValue];
    }];
    
    return [@(count) stringValue];
}

- (NSArray *)faultsXstatus
{
    return @[@"故障发生",@"故障受理",@"故障处理",@"故障恢复",@"客户关闭",@"故障关闭"];
}

- (NSMutableArray *)alarmsXStatus
{
    NSMutableArray *xStatus = [NSMutableArray arrayWithObjects:[NSNull null],[NSNull null],[NSNull null], nil];
    [self.alarmInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger number = [obj[@"alarmLevel"] integerValue] - 1;
        [xStatus replaceObjectAtIndex:(number) withObject:obj[@"alarmLevelName"]];
    }];
        
    [xStatus enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == [NSNull null])
        {
            [xStatus removeObjectAtIndex:idx];
        }
    }];
        
    return xStatus;
}

- (UIColor *)chartColorForDefaultPage
{
    return [UIColor colorWithRed:102/255.0 green:192/255.0 blue:251/255.0 alpha:1];
}

- (NSMutableArray *)alarmsNumberArray
{
    NSMutableArray *numbers = [NSMutableArray arrayWithObjects:[NSNull null],[NSNull null],[NSNull null], nil];
    [self.alarmInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id number = numbers[[obj[@"alarmLevel"] integerValue] - 1];
        if (number != [NSNull null])
        {
            [numbers replaceObjectAtIndex:([obj[@"alarmLevel"] integerValue] - 1) withObject:@([obj[@"count"] integerValue] + [number integerValue])];
        }
        else
        {
            [numbers replaceObjectAtIndex:([obj[@"alarmLevel"] integerValue] - 1) withObject:@([obj[@"count"] integerValue])];
        }
    }];
    
    [numbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqual:[NSNull null]])
        {
            [numbers removeObjectAtIndex:idx];
        }
    }];
    
    return numbers;
}

- (NSMutableArray *)alarmsChartColors
{
    NSMutableArray *alarmsNumberArray = [self alarmsNumberArray];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:alarmsNumberArray.count];
    for (int i = 0; i < alarmsNumberArray.count; i++)
    {
        [array addObject:[self chartColorForDefaultPage]];
    }
    
    return array;
}

- (NSMutableArray *)faultsNumberArray
{
    NSMutableArray *numbers = [NSMutableArray arrayWithArray:@[@(0),@(0),@(0),@(0),@(0),@(0)]];
    NSArray *xStatus = [self faultsXstatus];
    [self.faultInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
         NSInteger index = [xStatus indexOfObject:obj[@"statusName"]];
         [numbers replaceObjectAtIndex:index withObject:@([obj[@"count"] integerValue])];
     }];
    
    
    return numbers;
}

- (NSUInteger)maxFaultsNumber
{
    NSMutableArray *numbers = [self faultsNumberArray];
    __block NSInteger maxY = [numbers[0] integerValue];
    
    [numbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj integerValue] > maxY)
        {
            maxY = [obj integerValue];
        }
    }];
    
    if (maxY < 10)
    {
        maxY += 1;
    }
    else if (maxY < 20)
    {
        maxY += 3;
    }
    else if (maxY < 50)
    {
        maxY += 5;
    }
    else if (maxY <100)
    {
        maxY += 20;
    }
    else if (maxY < 500)
    {
        maxY += 50;
    }
    else if (maxY <1000)
    {
        maxY += 100;
    }
    
    return maxY;
}

- (NSUInteger)maxAlarmsNumber
{
    NSMutableArray *numbers = [self alarmsNumberArray];
    __block NSInteger maxY = [numbers[0] integerValue];
    
    [numbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != [NSNull null] && [obj integerValue] > maxY)
        {
            maxY = [obj integerValue];
        }
    }];
    
    if (maxY < 10)
    {
        maxY += 1;
    }
    else if (maxY < 20)
    {
        maxY += 3;
    }
    else if (maxY < 50)
    {
        maxY += 5;
    }
    else if (maxY <100)
    {
        maxY += 20;
    }
    else if (maxY < 500)
    {
        maxY += 50;
    }
    else if (maxY <1000)
    {
        maxY += 100;
    }
    return maxY;
}
@end
