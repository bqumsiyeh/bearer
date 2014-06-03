//
//  UIUtils.m
//  Bearer
//
//  Created by Basel Qumsiyeh on 5/31/14.
//  Copyright (c) 2014 Bearer. All rights reserved.
//

#import "UIUtils.h"

@implementation UIUtils

+ (CAGradientLayer*) loginGradient {
    
    UIColor *green = [UIColor colorWithRed:(23/255.0) green:(199/255.0) blue:(0/255.0) alpha:1.0];
    UIColor *silver = [UIColor colorWithRed:(120/255.0) green:(120/255.0) blue:(120/255.0) alpha:1.0];
    UIColor *white = [UIColor colorWithRed:(218/255.0) green:(222/255.0) blue:(217/255.0) alpha:1.0];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)green.CGColor, silver.CGColor, white.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.40];
    NSNumber *stopThree     = [NSNumber numberWithFloat:0.80];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}

@end
