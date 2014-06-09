//
//  BearerTableCell.h
//  Bearer
//
//  Created by Basel Qumsiyeh on 6/8/14.
//  Copyright (c) 2014 Bearer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BearerTableCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *mainLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UIImageView *actionImageView;
@property (nonatomic, strong) PFObject *sentContentRecord;

@end
