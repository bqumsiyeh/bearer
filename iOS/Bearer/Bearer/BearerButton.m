//
//  BearerButton.m
//  Bearer
//
//  Created by Basel Qumsiyeh on 6/1/14.
//  Copyright (c) 2014 Bearer. All rights reserved.
//

#import "BearerButton.h"

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
    
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 3.0f;
    UIColor *color = [UIColor colorWithRed:87/255.0f green:25/255.0f blue:185/255.0f alpha:1.0f];
    self.layer.borderColor= color.CGColor;
    self.backgroundColor = color;
}

@end
