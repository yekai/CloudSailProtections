//
//  CloudUtility.m
//  CloudSailProtection
//
//  Created by Ice on 12/21/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "CloudUtility.h"

@implementation CloudUtility

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+ (NSString *)stringFromDateNow
{
    return [self stringFromDate:[NSDate date]];
}

+ (NSString *)stringFromTodayStart
{
    NSString *dateString = [self stringFromDateNow];
    return [NSString stringWithFormat:@"%@000000",[dateString substringToIndex:8]];
}

+ (NSString *)stringFromTodayEnd
{
    NSString *dateString = [self stringFromDateNow];
    return [NSString stringWithFormat:@"%@235959",[dateString substringToIndex:8]];
}

+ (NSString *)stringFromYesterdayStart
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    NSDate *now = [NSDate date];
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:-1];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:now options:0];
    NSString *preDatesString = [self stringFromDate:newdate];
    return [NSString stringWithFormat:@"%@000000",[preDatesString substringToIndex:8]];
}

+ (NSString *)stringFromYesterdayEnd
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    NSDate *now = [NSDate date];
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:-1];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:now options:0];
    NSString *preDatesString = [self stringFromDate:newdate];
    return [NSString stringWithFormat:@"%@235959",[preDatesString substringToIndex:8]];
}

+ (NSString *)stringFromMonth
{
    NSString *dateString = [self stringFromDateNow];
    return [NSString stringWithFormat:@"%@01000000",[dateString substringToIndex:6]];
}

+ (NSString *)stringFromYear
{
    NSString *dateString = [self stringFromDateNow];
    return [NSString stringWithFormat:@"%d1231235959",[[dateString substringToIndex:4]intValue] - 1];
}

+ (NSString *)stringFromFiveDaysAgo
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    NSDate *now = [NSDate date];
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:-5];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:now options:0];
    NSString *preDatesString = [self stringFromDate:newdate];
    return [NSString stringWithFormat:@"%@235959",[preDatesString substringToIndex:8]];
}

+ (NSString *)stringFromFiveMonsAgo
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    NSDate *now = [NSDate date];
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:-5];
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:now options:0];
    NSString *preDatesString = [self stringFromDate:newdate];
    return [NSString stringWithFormat:@"%@235959",[preDatesString substringToIndex:8]];
}

+ (NSString *)stringFromFiveYearsAgo
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    NSDate *now = [NSDate date];
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:-5];
    [adcomps setMonth:0];
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:now options:0];
    NSString *preDatesString = [self stringFromDate:newdate];
    return [NSString stringWithFormat:@"%@235959",[preDatesString substringToIndex:8]];
}

+ (BOOL)isIphone6S
{
    return [UIScreen mainScreen].bounds.size.width > 375;
}

+ (NSString *)isNullString:(NSString *)string
{
    return [string isEqual:[NSNull null]] ? @"" : string;
}

+ (NSString *)stringForRoutingDateWithRoutingTime:(NSString *)intervalTime
{
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[intervalTime integerValue]/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:dateTime];
    
    return destDateString;
}
@end
