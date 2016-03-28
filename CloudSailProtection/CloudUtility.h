//
//  CloudUtility.h
//  CloudSailProtection
//
//  Created by Ice on 12/21/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CloudUtility : NSObject

+ (NSString *)stringFromDateNow;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (BOOL)isIphone6S;
+ (NSString *)isNullString:(NSString *)string;
+ (NSString *)stringFromMonth;
+ (NSString *)stringFromYear;
+ (NSString *)stringForRoutingDateWithRoutingTime:(NSString *)intervalTime;
@end

