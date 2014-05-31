//
//  LoginViewController.h
//  Bearer
//
//  Created by Basel Qumsiyeh on 5/24/14.
//  Copyright (c) 2014 Bearer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController


@property (nonatomic, strong) IBOutlet UITextField *emailTF;
@property (nonatomic, strong) IBOutlet UITextField *passwordTF;

- (IBAction)loginPressed:(id)sender;
- (IBAction)signUpPressed:(id)sender;
@end
