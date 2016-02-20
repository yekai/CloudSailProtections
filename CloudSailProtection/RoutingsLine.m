//
//  RoutingsLine.m
//  CloudSailProtection
//
//  Created by Ice on 1/3/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import "RoutingsLine.h"
#import "RightBottomBorderLabel.h"

@interface RoutingsLine ()
@property (weak, nonatomic) IBOutlet RightBottomBorderLabel *deviceName;
@property (weak, nonatomic) IBOutlet RightBottomBorderLabel *routingName;
@property (weak, nonatomic) IBOutlet RightBottomBorderLabel *routingValue;
@end


@implementation RoutingsLine

+ (RoutingsLine *)instanceForRoutingsLine
{
    RoutingsLine *routingLine = (RoutingsLine *)([[NSBundle mainBundle] loadNibNamed:@"RoutingsLine" owner:nil options:nil][0]);

    return routingLine;

}

- (RoutingsLine *)setValueForRoutingsLine:(RoutingObj *)routing
{
    self.deviceName.text = routing.name;
    self.routingName.text = routing.routingName;
    self.routingValue.text = routing.routingValue;
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
}

@end
