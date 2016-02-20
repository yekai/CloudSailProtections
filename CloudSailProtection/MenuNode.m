//
//  MenuNode.m
//  CloudSailProtection
//
//  Created by Ice on 11/14/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "MenuNode.h"

@implementation MenuNode

- (instancetype)initNodeWithDict:(NSDictionary *)nodeDict
{
    if (self = [super init])
    {
        self.title = nodeDict[@"title"];
        self.controllerIdentifier = nodeDict[@"identifier"];
        self.isLoginRequired = [nodeDict[@"isLoginRequired"] boolValue];
        self.nodeImage = nodeDict[@"nodeImage"];
    }
    
    return self;
}
@end
