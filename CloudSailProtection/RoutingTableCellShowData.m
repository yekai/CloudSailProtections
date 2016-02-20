//
//  RoutingTableCellShowData.m
//  CloudSailProtection
//
//  Created by Ice on 1/3/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import "RoutingTableCellShowData.h"
#import "RoutingsLine.h"
#import "RoutingObj.h"

@implementation RoutingTableCellShowData


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.layer.borderColor = [UIColor colorWithRed:16/255.0 green:133/255.0 blue:250/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 10;
}

- (void)setValueForRoutingTableCellData:(NSMutableArray *)data
{
    __block RoutingTableCellShowData *weakSelf = self;
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RoutingsLine *line = [[RoutingsLine instanceForRoutingsLine]setValueForRoutingsLine:obj];
        [weakSelf addSubview:line];
        [weakSelf addConstraintForSubview:line];
    }];
}

- (void)addConstraintForSubview:(RoutingsLine *)line
{
    // 1. Create a dictionary of views
    NSDictionary *viewsDictionary = @{@"lineView":line};
    
    // 2. Define the redView Size
    NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineView(20)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];
    
    NSString *VFL = [NSString stringWithFormat:@"H:[lineView(%f)]",self.bounds.size.width];
    NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:VFL
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];
    
    VFL = [NSString stringWithFormat:@"V:|-%ld-[lineView]",(self.subviews.count - 1) * 20];
    
    NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:VFL
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    
    NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lineView]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    [line addConstraints:constraint_H];
    [line addConstraints:constraint_V];
    
    [self addConstraints:constraint_POS_H];
    [self addConstraints:constraint_POS_V];
}
@end
