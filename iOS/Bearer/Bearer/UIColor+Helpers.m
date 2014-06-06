//
//  UIColor+Helpers.m
//  Bearer
//
//  Created by Basel Qumsiyeh on 6/3/14.
//  Copyright (c) 2014 Bearer. All rights reserved.
//

#import "UIColor+Helpers.h"

@implementation UIColor (Helpers)

+ (UIColor *) red:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b {
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
}

@end
