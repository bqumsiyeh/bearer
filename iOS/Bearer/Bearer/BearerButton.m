//
//  BearerButton.m
//  Bearer
//
//  Created by Basel Qumsiyeh on 6/1/14.
//  Copyright (c) 2014 Bearer. All rights reserved.
//

#import "BearerButton.h"
#import "UIColor+Helpers.h"

@implementation BearerButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = 4.0f;
    self.layer.borderWidth = 1.5f;
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backgroundColor = [UIColor red:37 green:103 blue:16];
}

@end
