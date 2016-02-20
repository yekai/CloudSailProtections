//
//  MenuNode.h
//  CloudSailProtection
//
//  Created by Ice on 11/14/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MenuNode : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *controllerIdentifier;
@property (nonatomic, assign) BOOL isLoginRequired;
@property (nonatomic, strong) UIImage *nodeImage;

- (instancetype)initNodeWithDict:(NSDictionary *)nodeDict;

@end
