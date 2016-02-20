//
//  Agreements.h
//  CloudSailProtection
//
//  Created by Ice on 12/25/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Agreements : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *serviceTime;
@property (nonatomic, copy) NSString *scenerate;
@property (nonatomic, copy) NSString *phoneRate;
@property (nonatomic, copy) NSString *remoteRate;
@property (nonatomic, copy) NSString *response;
@property (nonatomic, copy) NSString *reachScene;
@property (nonatomic, copy) NSString *solve;
@property (nonatomic, copy) NSString *startTimeString;
@property (nonatomic, copy) NSString *endTimeString;

- (instancetype)initWithAgreementsAttribute:(NSDictionary *)agreement;
@end
