//
//  PUEObj.h
//  CloudSailProtection
//
//  Created by Ice on 12/25/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PUEObj : NSObject

@property (nonatomic, copy) NSString *itEnergy;
@property (nonatomic, copy) NSString *pue;
@property (nonatomic, copy) NSString *totalEnergy;
@property (nonatomic, copy) NSString *time;

- (instancetype)initWithPUEAttribute:(NSDictionary *)pue;
@end
