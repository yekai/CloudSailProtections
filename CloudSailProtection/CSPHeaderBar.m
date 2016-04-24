//
//  CSPHeaderBar.m
//  CloudSailProtection
//
//  Created by Ice on 11/14/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "CSPHeaderBar.h"
#import "CSPGlobalConstants.h"
#import "DAAutoScroll.h"
#import "AMSmoothAlertView.h"

static BOOL isMessageViewDismiss = NO;

@interface CSPHeaderBar ()<AMSmoothAlertViewDelegate>
@property (nonatomic, weak) IBOutlet UIView *scrollContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewHeightConstraint;

@end

@implementation CSPHeaderBar

+ (BOOL)isDefaultPageNoticeDismiss
{
    return isMessageViewDismiss;
}

- (void)setupActionBar
{
    [self.actionBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton *actionBtn = (UIButton *)obj;
            [actionBtn addTarget:self action:@selector(actionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
    }];
}

- (void)actionButtonTapped:(UIButton *)sender
{
    [self.delegate didSelectActionBarItemAtIndex:sender.tag - kCSP_UserMenu_Tag];
}

- (void)reloadNotice
{
    [self setupActionBar];
    
    if (isMessageViewDismiss)
    {
        self.scrollContentViewHeightConstraint.constant = 0;
        return;
    }
    
    if ([[self.scrollContentView subviews]count] != 0)
    {
        return;
    }
    [self setupActionBar];
    NSArray *dataSources = self.delegate ? [self.delegate dataSourceForScrollView] : nil;
    __block NSUInteger width = 0;
    __weak CSPHeaderBar *weakSelf = self;
    [dataSources enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = weakSelf.scrollContentView.frame;
        UIButton *label = [weakSelf createBtnWithText:obj];
        NSUInteger originY = 0;
        NSUInteger originX = width;
        width += label.bounds.size.width + 20;
        label.frame = CGRectMake(originX, originY, label.bounds.size.width, frame.size.height);
        [weakSelf.scrollContentView addSubview:label];
    }];
    
    self.widthConstraint.constant = width < self.bounds.size.width ? self.bounds.size.width : width;
    [self updateConstraintsIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (UIButton *)createBtnWithText:(NSString *)text
{
    text = [NSString stringWithFormat:@"公告:%@",text];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.text = text;
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(didSelectNotice) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];

    return btn;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self startScrolling];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self startScrolling];
}

- (void)startScrolling
{
    [self.noticeScrollView startScrolling];
}

- (void)didSelectNotice
{
    AMSmoothAlertView *alert = [[AMSmoothAlertView alloc]initFadeAlertWithTitle:@"提示" andText:@"确实要关闭通知么？" andCancelButton:YES forAlertType:AlertInfo];
    [alert.defaultButton setTitle:@"确实" forState:UIControlStateNormal];
    [alert.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    alert.cornerRadius = 3.0f;
    alert.delegate = self;
    [alert show];
}

-(void) alertView:(AMSmoothAlertView *)alertView didDismissWithButton:(UIButton *)button
{
    if (alertView.defaultButton == button)
    {
        self.scrollContentViewHeightConstraint.constant = 0;
        isMessageViewDismiss = YES;
        [self.delegate didSelectNoticeAtIndex:0];
    }
}

-(void)reloadNoticeBar
{
    if (isMessageViewDismiss)
    {
        isMessageViewDismiss = NO;
        self.scrollContentViewHeightConstraint.constant = 42;
    }
    
    [self.delegate reloadNotices];
}
@end
