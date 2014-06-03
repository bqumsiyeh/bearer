//
//  ReceivedContentTableViewController.m
//  Bearer
//
//  Created by Basel Qumsiyeh on 5/26/14.
//  Copyright (c) 2014 Bearer. All rights reserved.
//

#import "ReceivedContentTableViewController.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>

@interface ReceivedContentTableViewController ()

@end

@implementation ReceivedContentTableViewController

@synthesize sentContentRecords;
@synthesize autoOpenRecordId;
@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bearer-gradient-background2"]];
    [self.view addSubview:background];
    [self.view sendSubviewToBack:background];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadDataFromParse) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor whiteColor];
    self.refreshControl = refreshControl;
    [self.tableView addSubview:self.refreshControl];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading Data";
    
    [self reloadDataFromParse];
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
    return self.sentContentRecords.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    
    PFObject *sentContent = [self.sentContentRecords objectAtIndex:indexPath.section];
    
    cell.textLabel.text = sentContent[@"text"];
    
    [cell.layer setCornerRadius:3.0f];
    [cell.layer setMasksToBounds:YES];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 38.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PFObject *sentContent = [self.sentContentRecords objectAtIndex:indexPath.section];
    [self openContent:sentContent];
}

#pragma mark - Opening content
- (void) openContent:(PFObject *)sentContent {
    if ([sentContent[@"route"] isEqualToString:@"SMS"]) {
        [self openSMS:sentContent];
    }
    //TODO add more stuff here
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
