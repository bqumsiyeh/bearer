//
//  BearerTextField.m
//  Bearer
//
//  Created by Basel Qumsiyeh on 5/31/14.
//  Copyright (c) 2014 Bearer. All rights reserved.
//

#import "BearerTextField.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Helpers.h"

@implementation BearerTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    
    if ([self respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor lightTextColor];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: color}];
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height-1.0f, self.frame.size.width, 1.0f);
        color = [[UIColor lightTextColor] colorWithAlphaComponent:0.3];
        bottomBorder.backgroundColor = color.CGColor;
        [self.layer addSublayer:bottomBorder];
    }
}
- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.borderStyle = UITextBorderStyleNone;
    self.backgroundColor = [UIColor clearColor];
//    self.layer.masksToBounds = NO;
//    self.layer.cornerRadius = 1;
//    self.layer.shadowOffset = CGSizeMake(0, 3);
//    self.layer.shadowRadius = 2;
//    self.layer.shadowOpacity = 0.5;
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

@end
