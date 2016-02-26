//
//  RightBottomBorderLabel.m
//  CloudSailProtection
//
//  Created by Ice on 1/3/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import "RightBottomBorderLabel.h"

@implementation RightBottomBorderLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGRect bounds = self.bounds;
    CGRect rightBorderFrame = CGRectMake(bounds.size.width - 1, 0, 1, bounds.size.height);
    CGRect bottomBorderFrame = CGRectMake(0, bounds.size.height - 1, bounds.size.width, 1);
    UIView *rightBorder = [[UIView alloc]initWithFrame:rightBorderFrame];
    UIView *bottomBorder = [[UIView alloc]initWithFrame:bottomBorderFrame];
    rightBorder.backgroundColor = [UIColor colorWithRed:160/255.0 green:211/255.0 blue:247/255.0 alpha:1];
    bottomBorder.backgroundColor = [UIColor colorWithRed:160/255.0 green:211/255.0 blue:247/255.0 alpha:1];
    [self addSubview:rightBorder];
    [self addSubview:bottomBorder];
    [super drawRect:rect];
}

@end

@implementation BottomBorderLabel

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGRect bounds = self.bounds;
    CGRect bottomBorderFrame = CGRectMake(0, bounds.size.height - 1, bounds.size.width, 1);
    UIView *bottomBorder = [[UIView alloc]initWithFrame:bottomBorderFrame];
    bottomBorder.backgroundColor = [UIColor colorWithRed:160/255.0 green:211/255.0 blue:247/255.0 alpha:1];
    [self addSubview:bottomBorder];
    [super drawRect:rect];
}

@end