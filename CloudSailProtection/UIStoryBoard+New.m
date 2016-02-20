//
//  UIStoryBoard+New.m
//  CloudSailProtection
//
//  Created by Ice on 11/14/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "UIStoryBoard+New.h"

@implementation UIStoryboard(createNew)

+ (__kindof UIViewController *)instantiateControllerWithIdentifier:(NSString *)identifier
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

@end
