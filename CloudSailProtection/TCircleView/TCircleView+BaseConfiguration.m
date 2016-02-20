//
//  TCircleView+BaseConfiguration.m
//  2015-06-29-圆形渐变进度条
//
//  Created by TangJR on 7/1/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//

#import "TCircleView+BaseConfiguration.h"
#import "TKit.h"

#define DEGREES_TO_RADOANS(x) (M_PI * (x) / 180.0) // 将角度转为弧度

@implementation TCircleView (BaseConfiguration)

+ (UIColor *)startColor {
    
    return [UIColor colorWithRed:235/255.0 green:104/255.0 blue:37/255.0 alpha:1];
}

+ (UIColor *)centerColor {
    
    return [UIColor greenColor];
}

+ (UIColor *)endColor {
    
    return [UIColor colorWithRed:64/255.0 green:144/255.0 blue:11/255.0 alpha:1];
}

+ (UIColor *)backgroundColor {
    
    return [UIColor clearColor];
}

+ (CGFloat)lineWidth {
    
    return 20;
}

+ (CGFloat)startAngle {
    
    return DEGREES_TO_RADOANS(-270);
}

+ (CGFloat)endAngle {
    
    return DEGREES_TO_RADOANS(90);
}

@end
