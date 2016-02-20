//
//  CSPHeaderBar.h
//  CloudSailProtection
//
//  Created by Ice on 11/14/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CSPHeaderBarDelegate

- (NSArray *)dataSourceForScrollView;
- (void)didSelectNoticeAtIndex:(NSUInteger)index;
- (void)didSelectActionBarItemAtIndex:(NSUInteger)index;
@end


@interface CSPHeaderBar : UIView<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *noticeScrollView;
@property (weak, nonatomic) IBOutlet UIView *actionBar;
@property (weak, nonatomic) id<CSPHeaderBarDelegate> delegate;

- (void)reloadNotice;
- (void)startScrolling;
+ (BOOL)isDefaultPageNoticeDismiss;
@end
