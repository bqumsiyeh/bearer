//
//  SignUpViewController.m
//  Bearer
//
//  Created by Basel Qumsiyeh on 5/26/14.
//  Copyright (c) 2014 Bearer. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController
@synthesize emailTF;
@synthesize passwordTF;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colorBackground.png"]];
    [self.view addSubview:background];
    [self.view sendSubviewToBack:background];
    
    [self setUpNavBar];
    
    UIGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
}

- (void) setUpNavBar {
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\U00002190" style:UIBarButtonItemStylePlain target:self action:@selector(backToLogin)];
}
- (void)handleSingleTap:(UITapGestureRecognizer *) sender {
    [self.view endEditing:YES];
}

- (void) enterApp {
    UIViewController *sentContentVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"receivedContentTable"];
    
    //[self.navigationController popViewControllerAnimated:NO];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 0.65];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:YES];
    [self.navigationController pushViewController:sentContentVC animated:NO];
    [UIView commitAnimations];
}

- (void) backToLogin {
    
    UIViewController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                 instantiateViewControllerWithIdentifier:@"logIn"];
    
    [self.navigationController popViewControllerAnimated:NO];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 0.65];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:YES];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:loginVC] animated:NO];
    [UIView commitAnimations];
}

- (IBAction)signUp:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.emailTF.text;
    user.password = self.passwordTF.text;
    user.email = self.emailTF.text;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"One moment...";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (!error) {
            PFInstallation *installation = [PFInstallation currentInstallation];
            installation[@"user"] = user;
            [installation saveInBackground];
            
            [self enterApp];
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:errorString
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }];
}

@end
