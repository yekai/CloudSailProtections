//
//  MenuNodeManager.h
//  CloudSailProtection
//
//  Created by Ice on 11/14/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuNodeManager : NSObject

+ (instancetype)sharedManager;
- (NSMutableArray *)menuNodes;
@end
