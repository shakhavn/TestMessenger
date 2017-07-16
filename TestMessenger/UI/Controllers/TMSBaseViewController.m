//
//  TMSBaseViewController.m
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 13/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import "TMSBaseViewController.h"

@interface TMSBaseViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSIndexPath *insertedRowIndexPath;

@end

@implementation TMSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Failed to initialize fetchedResultsController: %@\%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSFetchedResultsController*)setupFetchedResultsController {
    NSAssert(NO, @"This method must be overwritten in subclasses");
    return nil;
}

- (NSFetchedResultsController*)fetchedResultsController {
    if (_fetchedResultsController == nil) {
        _fetchedResultsController = [self setupFetchedResultsController];
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController*)controller didChangeSection:(nonnull id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(nonnull id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath {
    self.insertedRowIndexPath = nil;
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            self.insertedRowIndexPath = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:self.insertedRowIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(NO, @"This method must be overwritten in subclasses");
    return nil;
}

@end
