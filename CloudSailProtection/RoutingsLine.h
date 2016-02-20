//
//  RoutingsLine.h
//  CloudSailProtection
//
//  Created by Ice on 1/3/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoutingObj.h"

@interface RoutingsLine : UIView

+ (RoutingsLine *)instanceForRoutingsLine;
- (RoutingsLine *)setValueForRoutingsLine:(RoutingObj *)routing;
@end
