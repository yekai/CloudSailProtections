//
//  NPTab.m
//  iOrtho
//
//  Created by Arthur Hemmer on 07/08/14.
//  Copyright (c) 2014 Appsss. All rights reserved.
//

//Frameworks
#import <QuartzCore/QuartzCore.h>

//Views
#import "AHTabView.h"
#import "AHSubitemView.h"

//Categories
#import "UIImage+Overlay.h"

@interface AHTabView ()


//The label that displays the tab's title
@property (nonatomic) UILabel *titleLabel;


@end

@implementation AHTabView

-(void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self.titleLabel setTextColor:self.selectedColor];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:13.f]];
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:171/255.0 green:218/255.0 blue:243/255.0 alpha:1];
    } else {
        self.backgroundColor = [UIColor colorWithRed:211/255.0 green:229/255.0 blue:235/255.0 alpha:1];
    }
}

-(void)addSubitem:(AHSubitemView *)subitem
{
    [_subitems addObject:subitem];
    [subitem setTab:self];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //Some constants
    CGRect frame = self.frame;
    static const float kHorizontalSpacing = 20.f;
    static const float kVerticalSpacing = 1.f;
    static const float kLabelHeight = 20.f;
    
    UIColor *tintColor = self.selectedColor;
    
    //Create and setup the thumbnail imageview if it doesn't exist yet
    if (!self.thumbnail) {
        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.thumbnail setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:self.thumbnail];
    }
    
    //Set the thumbnail's frame and set the image
    CGRect tFrame = CGRectZero;
    tFrame.size.width = frame.size.width - 2*kHorizontalSpacing;
    tFrame.size.height = frame.size.height - (3*kVerticalSpacing + kLabelHeight) - 11.f;
    tFrame.origin.x = kHorizontalSpacing;
    tFrame.origin.y = 8*kVerticalSpacing;
    [self.thumbnail setFrame:tFrame];
    [self.thumbnail setImage:self.image];
    
    //Create and setup the titlelabel if it doesn't exist yet
    if (!self.titleLabel) {
        self.titleLabel = [UILabel new];
        [self.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
        [self.titleLabel setTextColor:tintColor];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self addSubview:self.titleLabel];
    }
    
    //Set the titlelabel's frame and text
    CGRect lFrame = CGRectZero;
    lFrame.size.width = frame.size.width - 2*kHorizontalSpacing;
    lFrame.size.height = kLabelHeight;
    lFrame.origin.x = kHorizontalSpacing;
    lFrame.origin.y = frame.size.height - (kVerticalSpacing + kLabelHeight);
    [self.titleLabel setFrame:lFrame];
    [self.titleLabel setText:self.title];
}

#pragma mark - Gestures
-(void)tapGestureRecognized:(UITapGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        !self.didSelectTab ?: self.didSelectTab(self);
    }
}

#pragma mark - Initialisation
-(void)setup
{
    _subitems = [NSMutableArray new];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tapGestureRecognized:)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:tapGestureRecognizer];
}

-(id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)dealloc
{
    [self setDidSelectTab:nil];
}

@end
