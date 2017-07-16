//
//  TMSConversationsViewController.m
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 11/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import "TMSConversationsViewController.h"
#import "TMSChatViewController.h"
#import "TMSUINavigationConstants.h"
#import "TMSMessagesService.h"
#import "Conversation+CoreDataClass.h"
#import "TMSBotUser.h"

@interface TMSConversationsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) Conversation* conversation;

@end

@implementation TMSConversationsViewController

@dynamic tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.participantMO.name;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(startNewConversation:)];
    self.navigationItem.rightBarButtonItem = addButton;
    // Start the Bot
    [TMSBotUser shared];
}

- (void)startNewConversation:(id)sender {
    self.conversation = [TMSMessagesService.sharedService newConversationForUser:self.participantMO];
    Participant *bot = [TMSBotUser.shared botUserInContext:self.fetchedResultsController.managedObjectContext];
    [self.conversation addParticipantsObject:bot];
    [self performSegueWithIdentifier:TMSOpenChatSegueIdentifier sender:nil];
}

- (NSFetchedResultsController*)setupFetchedResultsController {
    NSFetchRequest *request = [Conversation fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"participants contains %@", self.participantMO];
    [request setPredicate:predicate];
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];
    [request setSortDescriptors:@[dateSort]];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:TMSMessagesService.sharedService.mainContext sectionNameKeyPath:nil cacheName:nil];
    return fetchedResultsController;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"conversationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    Conversation *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.dateStyle = NSDateFormatterMediumStyle;
    cell.textLabel.text = [formatter stringFromDate:object.startDate];
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    self.conversation = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:TMSOpenChatSegueIdentifier sender:tableView];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:TMSOpenChatSegueIdentifier]) {
        // Pass over a reference to the selected conversation
        TMSChatViewController *chatVC = segue.destinationViewController;
        chatVC.speaker = self.participantMO;
        chatVC.conversation = self.conversation;
    }
}

@end
