// Post.h
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

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
@interface Post : NSObject

+ (NSURLSessionDataTask *)loginWithUserId:(NSString *)userId password:(NSString *)password andBlock:(void (^)(BOOL isSuccess))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getCorporationNoticeWithBlock:(void (^)(NSArray *noticeArray))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getAlarmsCountWithBlock:(void (^)(NSUInteger count))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getFaultsCountWithBlock:(void (^)(NSUInteger count))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getAlarmsWithBlock:(void (^)(NSArray *alarmArray))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getFaultsWithBlock:(void (^)(NSArray *faultsArray))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getHealthNumberWithBlock:(void (^)(NSUInteger count))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getDefaultPageAttributesWithBlock:(void (^)(NSDictionary *mainDict))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getPUEHisDataByPositionWithReportType:(NSString *)type successBlock:(void (^)(NSArray *puesArray))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getRoutiningInfoByDate:(BOOL)isToday andSuccessBlock:(void (^)(NSDictionary *routinsDict))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getCommunicationsInfoWithBlock:(void (^)(NSArray *communicationsArray))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getRoutingNumByTimeWithBlock:(void (^)(NSArray *routingNumArray))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getHostInfoWithBlock:(void (^)(NSArray *hostInfoArray))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getDeviceInfoWithBlock:(void (^)(NSArray *deviceInfoArray))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getDevicesInfosWithDeviceId:(NSString *)deviceId andBlock:(void (^)(NSArray *devicesInfosArray))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getNoticeHistoryWithBlock:(void (^)(NSArray *noticeHistoryArray))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getAgreementsInfoWithBlock:(void (^)(NSArray *agreementsArray))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getPUEDataWithBlock:(void (^)(NSDictionary *pueData))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getAlarmNumberByLevelWithBlock:(void (^)(NSArray *alarmLevel))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getAlarmNumberByTimeWithBlock:(void (^)(NSArray *alarmLevel))block andFailureBlock:(void (^)())fblock;
+ (NSURLSessionDataTask *)getFaultNumByTimeWithType:(NSString *)type successBlock:(void (^)(NSArray *routinsArray))block andFailureBlock:(void (^)())fblock;

+ (NSURLSessionDataTask *)getDeviceType1WithBlock:(void (^)(NSArray *alarmLevel))block andFailureBlock:(void (^)())fblock;

+ (NSURLSessionDataTask *)getDeviceType2WithType1:(NSString *)typeId  count:(NSString *)count successBlock:(void (^)(NSArray *alarmLevel))block andFailureBlock:(void (^)())fblock;

+ (NSURLSessionDataTask *)getAssetInfosWithAssetTypeId:(NSString *)typeId assetCount:(NSString*)count successBlock:(void (^)(NSArray *alarmLevel))block andFailureBlock:(void (^)())fblock;
@end
