//
//  Communicator.h
//  CloudSailProtection
//
//  Created by Ice on 12/25/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Communicator : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;

- (instancetype)initWithCommunicatorAttribute:(NSDictionary *)comm;
@end
