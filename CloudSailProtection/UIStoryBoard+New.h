//
//  UIStoryBoard+New.h
//  CloudSailProtection
//
//  Created by Ice on 11/14/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIStoryboard (createNew)

+ (__kindof UIViewController *)instantiateControllerWithIdentifier:(NSString *)identifier;

@end
