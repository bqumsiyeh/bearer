//
//  BearerTableCell.m
//  Bearer
//
//  Created by Basel Qumsiyeh on 6/8/14.
//  Copyright (c) 2014 Bearer. All rights reserved.
//

#import "BearerTableCell.h"
#import "AppDelegate.h"

@implementation BearerTableCell

@synthesize mainLabel;
@synthesize timeLabel;
@synthesize actionImageView;
@synthesize sentContentRecord;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    UIImage *smsImage = [AppDelegate symbolSetImgFromText:@"\U0000E399" fontSize:20.0f color:[UIColor blackColor]];
    [self.actionImageView setImage:smsImage];
}

- (void) setSentContentRecord:(PFObject *)sentContentRecord2 {
    sentContentRecord = sentContentRecord2;
    
    self.mainLabel.text = self.sentContentRecord[@"text"];
    
    NSString *timeStr = [self timeAgoFromDate:self.sentContentRecord.createdAt];
    self.timeLabel.text = timeStr;
}

#pragma mark - date formatting
-(NSString *)timeAgoFromDate:(NSDate *)date {
    NSDate *todayDate = [NSDate date];
    double ti = [date timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
    	return @"never";
    } else 	if (ti < 60) {
    	return @"just now";
    } else if (ti < 3600) {
    	int diff = round(ti / 60);
    	return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (ti < 86400) {
    	int diff = round(ti / 60 / 60);
    	return[NSString stringWithFormat:@"%d hours ago", diff];
    } else if (ti < 2629743) {
    	int diff = round(ti / 60 / 60 / 24);
    	return[NSString stringWithFormat:@"%d days ago", diff];
    } else {
    	return @"never";
    }
}
@end
