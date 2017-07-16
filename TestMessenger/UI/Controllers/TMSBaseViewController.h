//
//  TMSBaseViewController.h
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 13/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMSMessagesService.h"

@interface TMSBaseViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (readonly, nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
- (NSFetchedResultsController*)setupFetchedResultsController;

@property (weak, nonatomic) UITableView *tableView;

@end
