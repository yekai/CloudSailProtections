// Post.m
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "Post.h"
#import "User.h"
#import "SessionManager.h"
#import "AFAppDotNetAPIClient.h"
#import "CloudUtility.h"

static const NSString *kCloudRequestParseKey = @"com.alamofire.serialization.response.error.data";

@implementation Post


+ (NSURLSessionDataTask *)loginWithUserId:(NSString *)userId password:(NSString *)password andBlock:(void (^)(BOOL isSuccess))block andFailureBlock:(void (^)())fblock
{
    NSString *postString = [[NSString alloc]initWithFormat:@"UserInfo/Login/%@",userId];
    return [[AFAppDotNetAPIClient sharedClient] POST:postString
                                   parameters:@{@"pwd":password}
                                      success:^(NSURLSessionDataTask * __unused task, id JSON) {}
                                      failure:^(NSURLSessionDataTask *__unused task, NSError *error)
     {
         NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
         BOOL isSuccess = YES;
         NSError *parseError = nil;
         id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
         
         if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
         {
             NSLog(@"json parse failure");
             isSuccess = NO;
         }
         else
         {
             [[SessionManager sharedManager]configWithLoginInfo:jsonObj andPassword:password];
         }
         
         if (block)
         {
             block(isSuccess);
         }
         
         if (!isSuccess)
         {
             fblock();
         }

     }];
}

+ (NSURLSessionDataTask *)getCorporationNoticeWithBlock:(void (^)(NSArray *))block andFailureBlock:(void (^)())fblock
{
    NSString *dateString = [CloudUtility stringFromDateNow];
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *password = [[SessionManager sharedManager].user password];
    NSString *token = [[SessionManager sharedManager]token];
    
    NSString *requestPath = [NSString stringWithFormat:@"notice/info/GetCorporationNotice/%@/%@/%@/%@",dateString, userId,password,token];
    
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                          parameters:nil
                                             success:^(NSURLSessionDataTask * __unused task, id JSON){}
                                             failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }
                
                if (block && jsonObj)
                {
                    block(jsonObj[@"realnotices"]);
                }
                
                if (!isSuccess)
                {
                    fblock();
                }
                
            }];
}

+ (NSURLSessionDataTask *)getAlarmsCountWithBlock:(void (^)(NSUInteger count))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];

    NSString *requestPath = [NSString stringWithFormat:@"alarm/info/GetAlarmNumByTime/Yea/20120807090733/20150807090733/-1/-1/%@/%@/%@", userId,password,token];
    
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){}
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }

                
                if (block && jsonObj)
                {
                    block([jsonObj[@"alarmnum"] count]);
                }
                if (!isSuccess)
                {
                    fblock();
                }
            }];
}

+ (NSURLSessionDataTask *)getFaultsCountWithBlock:(void (^)(NSUInteger count))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    NSString *dateString = [CloudUtility stringFromDateNow];

    NSString *requestPath = [NSString stringWithFormat:@"fault/info/GetFaultNumByTime/Yea/20120807090733/%@/-1/%@/%@/%@",dateString, userId,password,token];
    
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){}
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }
                
                if (block && jsonObj)
                {
                    block([jsonObj[@"faultnum"] count]);
                }
                if (!isSuccess)
                {
                    fblock();
                }
            }];
}

+ (NSURLSessionDataTask *)getHealthNumberWithBlock:(void (^)(NSUInteger))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    
    NSString *requestPath = [NSString stringWithFormat:@"health/info/gethealth/%@/%@/%@", userId,password,token];
    
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){}
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }

                
                if (block && jsonObj)
                {
                    block([jsonObj[@"health"] integerValue]);
                }
                if (!isSuccess)
                {
                    fblock();
                }
            }];
}

+ (NSURLSessionDataTask *)getAlarmsWithBlock:(void (^)(NSArray *alarmArray))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    NSString *dateString = [CloudUtility stringFromDateNow];

    NSString *requestPath = [NSString stringWithFormat:@"alarm/info/GetAlarmInfo/-1/20120807090733/%@/-1/-1/alarmTime desc/1/10/%@/%@/%@",dateString, userId,password,token];
    requestPath =  [requestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/-"]];
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){}
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }

                
                if (block && jsonObj)
                {
                    block(jsonObj[@"alarmInfos"]);
                }
                if (!isSuccess)
                {
                    fblock();
                }
            }];

}

+ (NSURLSessionDataTask *)getFaultsWithBlock:(void (^)(NSArray *faultsArray))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    NSString *dateString = [CloudUtility stringFromDateNow];
    NSString *yearDateString = [CloudUtility stringFromYear];

    NSString *requestPath = [NSString stringWithFormat:@"fault/info/GetFaultInfo/%@/%@/-1/createTime desc/1/200/%@/%@/%@",yearDateString, dateString, userId,password,token];
    requestPath =  [requestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/-"]];
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){}
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }

                
                if (block && jsonObj)
                {
                    block(jsonObj[@"faultInfos"]);
                }
                if (!isSuccess)
                {
                    fblock();
                }
            }];
}

+ (NSURLSessionDataTask *)getDefaultPageAttributesWithBlock:(void (^)(NSDictionary *))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    NSString *requestPath = [NSString stringWithFormat:@"main/info/getMain/%@/%@/%@", userId,password,token];
    requestPath =  [requestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/-"]];
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){}
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }
                
                if (block && jsonObj)
                {
                    block(jsonObj);
                }
                
                if (!isSuccess)
                {
                    fblock();
                }
            }];
}

+ (NSURLSessionDataTask *)getPUEHisDataByPositionWithReportType:(NSString *)type successBlock:(void (^)(NSArray *))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    NSString *dateString = [CloudUtility stringFromDateNow];
    NSString *previousString = nil;
    if ([type isEqualToString:@"Day"])
    {
        previousString = [CloudUtility stringFromFiveDaysAgo];
    }
    else if ([type isEqualToString:@"Mon"])
    {
        previousString = [CloudUtility stringFromFiveMonsAgo];
    }
    else if ([type isEqualToString:@"Yea"])
    {
        previousString = [CloudUtility stringFromFiveYearsAgo];
    }

    NSString *requestPath = [NSString stringWithFormat:@"getPUEHisDataByPosition/%@/%@/%@/%@/%@/%@", type, previousString, dateString, userId,password,token];
    requestPath =  [requestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/-"]];
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){}
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }

                
                if (block && jsonObj)
                {
                    block(jsonObj[@"datas"]);
                }
                if (!isSuccess)
                {
                    fblock();
                }
            }];

}

+ (NSURLSessionDataTask *)getRoutiningInfoByDate:(BOOL)isToday andSuccessBlock:(void (^)(NSDictionary *routinsDict))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    
    NSString *dateString = isToday ? [CloudUtility stringFromTodayEnd] : [CloudUtility stringFromYesterdayEnd];
    NSString *previousDateString = isToday ? [CloudUtility stringFromTodayStart] : [CloudUtility stringFromYesterdayStart];
    
    NSString *requestPath = [NSString stringWithFormat:@"GetRoutingInfo/%@/%@/-1/time asc/%@/%@/%@",previousDateString, dateString, userId,password,token];
    requestPath =  [requestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/-"]];
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){}
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"] || !jsonObj[@"routings"] || [jsonObj[@"routings"] count] == 0)
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }
                if (!isSuccess)
                {
                    fblock();
                    return ;
                }
                if (block && jsonObj)
                {
                    block(jsonObj[@"routings"][0]);
                }

            }];
}

+ (NSURLSessionDataTask *)getCommunicationsInfoWithBlock:(void (^)(NSArray *communicationsArray))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    NSString *requestPath = [NSString stringWithFormat:@"linkman/%@/%@/%@", userId,password,token];
    requestPath =  [requestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/-"]];
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){}
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }

                
                if (block && jsonObj)
                {
                    block(jsonObj[@"linkmans"]);
                }
                if (!isSuccess)
                {
                    fblock();
                }
            }];
}

+ (NSURLSessionDataTask *)getRoutingNumByTimeWithBlock:(void (^)(NSArray *routingNumArray))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    NSString *dateString = [CloudUtility stringFromDateNow];

    NSString *requestPath = [NSString stringWithFormat:@"GetRoutingNumByTime/Yea/20120807090733/%@/-1/%@/%@/%@", dateString, userId,password,token];
    requestPath =  [requestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/-"]];
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){}
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }

                
                if (block && jsonObj)
                {
                    block(jsonObj[@"routingnum"]);
                }
                if (!isSuccess)
                {
                    fblock();
                }
            }];
}

+ (NSURLSessionDataTask *)getHostInfoWithBlock:(void (^)(NSArray *))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    NSString *requestPath = [NSString stringWithFormat:@"GetPersonInfo/%@/%@/%@", userId,password,token];
    requestPath =  [requestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/-"]];
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){}
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }

                
                if (block && jsonObj)
                {
                    block(jsonObj[@"personinfo"]);
                }
                if (!isSuccess)
                {
                    fblock();
                }
            }];
}

+ (NSURLSessionDataTask *)getDeviceInfoWithBlock:(void (^)(NSArray *deviceInfoArray))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    NSString *requestPath = [NSString stringWithFormat:@"GetDeviceInfo/%@/%@/%@/1/20", userId,password,token];
    requestPath =  [requestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/-"]];
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){}
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }

                
                if (block && jsonObj)
                {
                    block(jsonObj[@"devicetypes"]);
                }
                if (!isSuccess)
                {
                    fblock();
                }
            }];
}

+ (NSURLSessionDataTask *)getDevicesInfosWithDeviceId:(NSString *)deviceId andBlock:(void (^)(NSArray *))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    NSString *requestPath = [NSString stringWithFormat:@"GetDeviceData/%@/%@/%@/%@",deviceId,userId,password,token];
    requestPath =  [requestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/-"]];
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){}
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }

                
                if (block && jsonObj)
                {
                    block(jsonObj[@"devicesInfos"]);
                }
                
                if (!isSuccess)
                {
                    fblock();
                }
            }];
}

+ (NSURLSessionDataTask *)getNoticeHistoryWithBlock:(void (^)(NSArray *noticeHistoryArray))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    NSString *dateString = [CloudUtility stringFromDateNow];

    NSString *requestPath = [NSString stringWithFormat:@"GetnoticeHistory/20000807090733/%@/%@/%@/%@",dateString, userId,password,token];
    requestPath =  [requestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/-"]];
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){
                                            
                                            }
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }

                
                if (block && jsonObj)
                {
                    block(jsonObj[@"notices"]);
                }
                if (!isSuccess)
                {
                    fblock();
                }
            }];
}

+ (NSURLSessionDataTask *)getAgreementsInfoWithBlock:(void (^)(NSArray *))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    NSString *requestPath = [NSString stringWithFormat:@"GetAgreeMentInfo/%@/%@/%@", userId,password,token];
    requestPath =  [requestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/-"]];
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){
                                                
                                            }
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }
                
                if (block && jsonObj)
                {
                    block(jsonObj[@"agreements"]);
                }
                if (!isSuccess)
                {
                    fblock();
                }
            }];
}

+ (NSURLSessionDataTask *)getPUEDataWithBlock:(void (^)(NSDictionary *pueData))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    
    NSString *requestPath = [NSString stringWithFormat:@"getPUEData/%@/%@/%@", userId,password,token];
    
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){}
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }

                
                if (block && jsonObj)
                {
                    block(jsonObj[@"puedatas"][0]);
                }
                if (!isSuccess)
                {
                    fblock();
                }
            }];

}

+ (NSURLSessionDataTask *)getAlarmNumberByLevelWithBlock:(void (^)(NSArray *))block andFailureBlock:(void (^)())fblock
{    
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    NSString *dateString = [CloudUtility stringFromDateNow];

    NSString *requestPath = [NSString stringWithFormat:@"alarm/info/GetAlarmNumByLevel/Yea/20120807090733/%@/-1/%@/%@/%@",dateString, userId,password,token];
    requestPath =  [requestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/-"]];
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){
                                                
                                            }
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }

                
                if (block && jsonObj)
                {
                    block(jsonObj[@"alarmlevelnum"]);
                }
                if (!isSuccess)
                {
                    fblock();
                }
            }];
}

+ (NSURLSessionDataTask *)getAlarmNumberByTimeWithBlock:(void (^)(NSArray *alarmLevel))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    NSString *dateString = [CloudUtility stringFromDateNow];
    
    NSString *requestPath = [NSString stringWithFormat:@"alarm/info/GetAlarmNumByTime/Yea/20120807090733/%@/-1/%@/%@/%@",dateString, userId,password,token];
    requestPath =  [requestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/-"]];
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){
                                                
                                            }
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }
                
                
                if (block && jsonObj)
                {
                    block(jsonObj[@"alarmnum"]);
                }
                if (!isSuccess)
                {
                    fblock();
                }
            }];

}

+ (NSURLSessionDataTask *)getFaultNumByTimeWithType:(NSString *)type successBlock:(void (^)(NSArray *routinsArray))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    NSString *dateString = [CloudUtility stringFromDateNow];
    
    NSString *selectedFirstDateString = nil;
    
    if ([type isEqualToString:@"Day"])
    {
        selectedFirstDateString = [CloudUtility stringFromFiveDaysAgo];
    }
    else if ([type isEqualToString:@"Mon"])
    {
        selectedFirstDateString = [CloudUtility stringFromFiveMonsAgo];
    }
    else if ([type isEqualToString:@"Yea"])
    {
        selectedFirstDateString = [CloudUtility stringFromFiveYearsAgo];
    }
    
    NSString *requestPath = [NSString stringWithFormat:@"fault/info/GetFaultNumByTime/%@/%@/%@/-1/time asc/%@/%@/%@",type,selectedFirstDateString,dateString, userId,password,token];
    requestPath =  [requestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/-"]];
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){
                                                
                                            }
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }
                
                
                if (block && jsonObj)
                {
                    block(jsonObj[@"faultnum"]);
                }
                if (!isSuccess)
                {
                    fblock();
                }
            }];
}

+ (NSURLSessionDataTask *)getDeviceType1WithBlock:(void (^)(NSArray *alarmLevel))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    
    NSString *requestPath = [NSString stringWithFormat:@"GetDeviceType1/%@/%@/%@/1/10",userId,password,token];
    requestPath =  [requestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/-"]];
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){
                                                
                                            }
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }
                
                
                if (block && jsonObj)
                {
                    block(jsonObj[@"devicetypes"]);
                }
                if (!isSuccess)
                {
                    fblock();
                }
            }];
}

+ (NSURLSessionDataTask *)getDeviceType2WithType1:(NSString *)typeId count:(NSString *)count successBlock:(void (^)(NSArray *alarmLevel))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    
    NSString *requestPath = [NSString stringWithFormat:@"GetDeviceType2/%@/%@/%@/%@/1/%@",typeId, userId,password,token,count];
    requestPath =  [requestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/-"]];
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){
                                                
                                            }
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }
                
                
                if (block && jsonObj)
                {
                    block(jsonObj[@"devicetypes"]);
                }
                if (!isSuccess)
                {
                    fblock();
                }
            }];
}


+ (NSURLSessionDataTask *)getAssetInfosWithAssetTypeId:(NSString *)typeId assetCount:(NSString*)count successBlock:(void (^)(NSArray *alarmLevel))block andFailureBlock:(void (^)())fblock
{
    NSString *userId = [[SessionManager sharedManager].user loginId];
    NSString *token = [[SessionManager sharedManager]token];
    NSString *password = [[SessionManager sharedManager].user password];
    
    NSString *requestPath = [NSString stringWithFormat:@"GetAssetInfos/%@/%@/%@/%@/1/%@", userId,password,token,typeId,count];
    requestPath =  [requestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/-"]];
    return [[AFAppDotNetAPIClient sharedClient] GET:requestPath
                                         parameters:nil
                                            success:^(NSURLSessionDataTask * __unused task, id JSON){
                                                
                                            }
                                            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                NSData *loginResponse = [error userInfo][kCloudRequestParseKey];
                BOOL isSuccess = YES;
                NSError *parseError = nil;
                
                id jsonObj = loginResponse ? [NSJSONSerialization JSONObjectWithData:loginResponse options:NSJSONReadingMutableContainers error:&parseError] : nil;
                
                if (!jsonObj || parseError || ![jsonObj[@"errorcode"] isEqualToString:@"0"])
                {
                    NSLog(@"json parse failure");
                    isSuccess = NO;
                }
                
                
                if (block && jsonObj)
                {
                    block(jsonObj[@"assetInfos"]);
                }
                if (!isSuccess)
                {
                    fblock();
                }
            }];
}
@end
