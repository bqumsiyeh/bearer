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
    
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.layer.cornerRadius = 3.0f;
    UIColor *color = [UIColor red:132 green:3 blue:252];
    self.backgroundColor = color;
}

@end
