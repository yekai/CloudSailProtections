//
//  Notice.h
//  CloudSailProtection
//
//  Created by Ice on 12/21/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notice : NSObject

@property (nonatomic, copy) NSString *noticeId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *recordtimeString;

- (instancetype)initWithAttribute:(NSDictionary *)notice;
@end
