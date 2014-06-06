//
//  LoginViewController.m
//  Bearer
//
//  Created by Basel Qumsiyeh on 5/24/14.
//  Copyright (c) 2014 Bearer. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "IIViewDeckController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize emailTF, passwordTF;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	//[PFUser logOut];
    
    if ([PFUser currentUser]) {
        [self enterApp];
        return;
    }
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bearer-gradient-background2"]];
    [self.view addSubview:background];
    [self.view sendSubviewToBack:background];
    
    UIGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender {
    [self.view endEditing:YES];
}

- (void) enterApp {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIViewController *sentContentVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"receivedContentTable"];
    
    UIViewController *menuVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"menu"];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:sentContentVC];
    
    
    IIViewDeckController* deckController = [[IIViewDeckController alloc] initWithCenterViewController:nav
                                                                                   leftViewController:menuVC
                                                                                  rightViewController:nil];
    
    deckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    deckController.delegateMode = IIViewDeckDelegateAndSubControllers;
    deckController.leftSize = 30.0f;
    
    appDelegate.viewDeck = deckController;
    
    [self.navigationController popViewControllerAnimated:NO];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 0.65];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:YES];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:deckController] animated:NO];
    [UIView commitAnimations];
}

//Email = username
- (IBAction)loginPressed:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Logging in";
    
    [PFUser logInWithUsernameInBackground:self.emailTF.text password:self.passwordTF.text
            block:^(PFUser *user, NSError *error) {
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                if (user) {
                    
                    PFInstallation *installation = [PFInstallation currentInstallation];
                    installation[@"user"] = user;
                    [installation saveInBackground];
                    
                    [self enterApp];
                } else {

                }
    }];
}

- (IBAction)signUpPressed:(id)sender {
    UIViewController *signUpVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"signUp"];
    
    [self.navigationController popViewControllerAnimated:NO];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 0.65];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:YES];
    [self.navigationController pushViewController:signUpVC animated:NO];
    [UIView commitAnimations];
}
@end
