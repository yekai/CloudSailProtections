//
//  Routing.h
//  CloudSailProtection
//
//  Created by Ice on 12/25/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Routing : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *routingid;
@property (nonatomic, copy) NSString *routingname;
@property (nonatomic, copy) NSString *routingvalue;
@property (nonatomic, copy) NSString *time;

- (instancetype)initWithRoutingAttributes:(NSDictionary *)routing;
@end
