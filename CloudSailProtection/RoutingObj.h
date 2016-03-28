//
//  RoutingObj.h
//  CloudSailProtection
//
//  Created by Ice on 1/3/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoutingObj : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger routingStatus;
@property (nonatomic, copy) NSString *routingName;
@property (nonatomic, copy) NSString *routingValue;

- (instancetype)initWithRoutingAttributes:(NSDictionary *)dict;
@end
