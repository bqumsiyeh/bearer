//
//  ReceivedContentTableViewController.h
//  Bearer
//
//  Created by Basel Qumsiyeh on 5/26/14.
//  Copyright (c) 2014 Bearer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ReceivedContentTableViewController : UITableViewController<MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *sentContentRecords;

@end
