//
//  MenuViewController.m
//  Bearer
//
//  Created by Basel Qumsiyeh on 6/5/14.
//  Copyright (c) 2014 Bearer. All rights reserved.
//

#import "MenuViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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
    // Do any additional setup after loading the view.
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bearer-gradient-background2"]];
    [self.view addSubview:background];
    [self.view sendSubviewToBack:background];
}


- (IBAction)logOut:(id)sender {
    [PFUser logOut];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.viewDeck toggleLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        if (success) {
            
            UIViewController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                               instantiateViewControllerWithIdentifier:@"logIn"];
            
            [appDelegate.viewDeck.navigationController popViewControllerAnimated:NO];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration: 0.65];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:YES];
            [appDelegate.viewDeck.navigationController setViewControllers:[NSArray arrayWithObject:loginVC] animated:NO];
            [UIView commitAnimations];
            
            appDelegate.viewDeck = nil;
            
        }
    }];
}

@end
