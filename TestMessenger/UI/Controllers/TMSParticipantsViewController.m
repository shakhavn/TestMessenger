//
//  TMSParticipantsViewController.m
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 11/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import "TMSParticipantsViewController.h"
#import "TMSMessagesService.h"
#import "TMSUINavigationConstants.h"
#import "TMSConversationsViewController.h"

@interface TMSParticipantsViewController () <NSFetchedResultsControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation TMSParticipantsViewController

@dynamic tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
}

- (void)test {
    [TMSMessagesService.sharedService performBackgroundTask:^(NSManagedObjectContext *context) {
        for(int i=0; i<10; i++) {
            [TMSMessagesService.sharedService addUserWithName:[NSString stringWithFormat:@"Tester-%i", i] inContext:context];
        }
    }];
}

- (NSFetchedResultsController*)setupFetchedResultsController {
    NSFetchRequest *request = [Participant fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isBot = NO"];
    [request setPredicate:predicate];
    NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [request setSortDescriptors:@[nameSort]];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:TMSMessagesService.sharedService.mainContext sectionNameKeyPath:nil cacheName:nil];
    return fetchedResultsController;
}

- (IBAction)registerUser:(id)sender {
    [self.textField resignFirstResponder];
    // Create a new participant object
    NSString *name = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (name.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"User Registration Error"
                                                                       message:@"Name field must be non-empty."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (![TMSMessagesService.sharedService addUserWithName:name]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"User Registration Error"
                                                                       message:[NSString stringWithFormat:@"Cannot register user with name \"%@\". Such name may already be registered.", name]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:TMSShowConversationsSegueIdentifier]) {
        // Pass over a reference to the selected user
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        id selectedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
        TMSConversationsViewController *conversationsVC = segue.destinationViewController;
        conversationsVC.participantMO = selectedObject;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"participantCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    Participant *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = object.name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Existing Users";
}

@end
