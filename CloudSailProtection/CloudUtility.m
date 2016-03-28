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

+ (NSString *)stringFromMonth
{
    NSString *dateString = [self stringFromDateNow];
    return [NSString stringWithFormat:@"%@01000000",[dateString substringToIndex:6]];
}

+ (NSString *)stringFromYear
{
    NSString *dateString = [self stringFromDateNow];
    return [NSString stringWithFormat:@"%@0101000000",[dateString substringToIndex:4]];
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
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[intervalTime integerValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:dateTime];
    
    return destDateString;
}
@end
