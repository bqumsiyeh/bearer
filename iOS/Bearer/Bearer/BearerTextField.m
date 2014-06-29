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

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}
//
- (void) willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    
    if ([self respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor lightGrayColor];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    }
}

//- (void) layoutSubviews {
//    [super layoutSubviews];
//    
//    self.borderStyle = UITextBorderStyleNone;
//    self.backgroundColor = [UIColor clearColor];
//}
//
//// placeholder position
//- (CGRect)textRectForBounds:(CGRect)bounds {
//    return CGRectInset( bounds , 10 , 10 );
//}
//
//// text position
//- (CGRect)editingRectForBounds:(CGRect)bounds {
//    return CGRectInset( bounds , 10 , 10 );
//}

- (void) layoutSubviews {
    [super layoutSubviews];

    self.borderStyle = UITextBorderStyleRoundedRect;
    
    self.layer.cornerRadius = 1.5f;
    self.layer.borderWidth = 1.5f;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.backgroundColor = [UIColor whiteColor];
}

@end
