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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadDataFromParse) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    
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
    
    if (!error) {
        
    }
    else {
        NSString *errorString = [error userInfo][@"error"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error loading data"
                                                        message:errorString
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    
    PFObject *sentContent = [self.sentContentRecords objectAtIndex:indexPath.row];
    
    cell.textLabel.text = sentContent[@"text"];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PFObject *sentContent = [self.sentContentRecords objectAtIndex:indexPath.row];
    if ([sentContent[@"type"] isEqualToString:@"SMS"]) {
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

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
