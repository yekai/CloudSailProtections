//
//  NoticesTableViewCell.m
//  CloudSailProtection
//
//  Created by Ice on 12/13/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "NoticesTableViewCell.h"
#import "Notice.h"
#import "CloudUtility.h"

@interface NoticesTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end


@implementation NoticesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueFromNotice:(Notice *)notice withIndex:(NSInteger)index
{
    self.name.text = [NSString stringWithFormat: @"公告信息%ld",index];
    self.date.text = [CloudUtility isNullString: notice.recordtimeString];
    self.content.text = [CloudUtility isNullString: notice.content];
}

@end
