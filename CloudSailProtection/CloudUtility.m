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

+ (BOOL)isIphone6S
{
    return [UIScreen mainScreen].bounds.size.width > 375;
}
@end
