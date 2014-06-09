//
//  ReceivedContentTableViewController.m
//  Bearer
//
//  Created by Basel Qumsiyeh on 5/26/14.
//  Copyright (c) 2014 Bearer. All rights reserved.
//

#import "ReceivedContentTableViewController.h"
#import "MBProgressHUD.h"
#import "UIColor+Helpers.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "BearerTableCell.h"

@interface ReceivedContentTableViewController ()

@end

@implementation ReceivedContentTableViewController

@synthesize sentContentRecords;
@synthesize autoOpenRecordId;
@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureNavBar];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadDataFromParse) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor red:87 green:25 blue:185];
    self.refreshControl = refreshControl;
    [self.tableView addSubview:self.refreshControl];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading Data";
    
    [self reloadDataFromParse];
}

- (void) configureNavBar {
    self.title = @"Inbox";
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.backBarButtonItem = nil;
    self.navigationController.navigationBar.barTintColor = [UIColor red:87 green:25 blue:185];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    UIImage *settingsImg = [AppDelegate symbolSetImgFromText:@"\U00002699" fontSize:20.0f color:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:settingsImg style:UIBarButtonItemStylePlain target:self action:@selector(menuBtnPressed)];
    
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)menuBtnPressed {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.viewDeck toggleLeftViewAnimated:YES];
}

- (void) reloadDataFromParse {
    
    PFQuery *query = [PFQuery queryWithClassName:@"SentContent"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            self.sentContentRecords = [objects mutableCopy];
        }
        
        
        [self performSelectorOnMainThread:@selector(doneLoadingData:) withObject:error waitUntilDone:NO];
    }];
}

- (void) doneLoadingData:(NSError *)error {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.refreshControl endRefreshing];
    
    if (error) {
        NSString *errorString = [error userInfo][@"error"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error loading data"
                                                        message:errorString
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    if (self.autoOpenRecordId) {
        
        for (PFObject *record in self.sentContentRecords) {
            if ([record.objectId isEqualToString:self.autoOpenRecordId]) {
                [self openContent:record];
                break;
            }
            
        }
        
        //clear
        self.autoOpenRecordId = nil;
    }
    [self.tableView reloadData];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sentContentRecords.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BearerTableCell *cell = (BearerTableCell *)[self.tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    
    PFObject *sentContent = [self.sentContentRecords objectAtIndex:indexPath.row];
    [cell setSentContentRecord:sentContent];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PFObject *sentContent = [self.sentContentRecords objectAtIndex:indexPath.row];
    [self openContent:sentContent];
}

#pragma mark - Opening content
- (void) openContent:(PFObject *)sentContent {
    if ([sentContent[@"route"] isEqualToString:@"SMS"]) {
        [self openSMS:sentContent];
    }
}

- (void) openSMS:(PFObject *)sentContent {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    MFMessageComposeViewController *smsWindow = [[MFMessageComposeViewController alloc] init];
    smsWindow.messageComposeDelegate = self;
    smsWindow.body = sentContent[@"text"];
    [self presentViewController:smsWindow animated:YES completion:NULL];
}

#pragma mark - SMS delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
