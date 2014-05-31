//
//  SignUpViewController.h
//  Bearer
//
//  Created by Basel Qumsiyeh on 5/26/14.
//  Copyright (c) 2014 Bearer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *emailTF;
@property (nonatomic, strong) IBOutlet UITextField *passwordTF;

- (IBAction)signUp:(id)sender;

@end
