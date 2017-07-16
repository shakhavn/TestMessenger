//
//  TMSChatViewController.m
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 11/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import "TMSChatViewController.h"
#import "Message+CoreDataProperties.h"
#import "TMSTextMessageTableViewCell.h"
#import "TMSImageMessageTableViewCell.h"
#import "TMSLocationMessageTableViewCell.h"
#import "TMSMessagesQueue.h"

@interface TMSChatViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlsBottomConstraint;

@property (nonatomic, readonly) CLLocationManager *locationManager;

@end

static NSString * const kTextCellIdentifier = @"textCell";
static NSString * const kImageCellIdentifier = @"imageCell";
static NSString * const kLocationCellIdentifier = @"locationCell";

@implementation TMSChatViewController

@dynamic tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy.MM.dd hh:mm:ss";
    formatter.locale = [NSLocale currentLocale];
    self.navigationItem.title = [formatter stringFromDate:self.conversation.startDate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.textField.delegate = self;
    [self.textField becomeFirstResponder];
    // Ask for authorization to get user's current location
    CLLocationManager *manager = [[CLLocationManager alloc]init];
    manager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    manager.distanceFilter = kCLDistanceFilterNone;
    _locationManager = manager;
    [self.locationManager requestWhenInUseAuthorization];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSFetchedResultsController*)setupFetchedResultsController {
    NSFetchRequest *request = [Message fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"conversation = %@", self.conversation];
    [request setPredicate:predicate];
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [request setSortDescriptors:@[dateSort]];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:TMSMessagesService.sharedService.mainContext sectionNameKeyPath:nil cacheName:nil];
    return fetchedResultsController;
}

- (void)sendText:(NSString*)text {
    Message *message = [NSEntityDescription insertNewObjectForEntityForName:self.fetchedResultsController.fetchRequest.entityName
                                                     inManagedObjectContext:self.fetchedResultsController.managedObjectContext];
    message.data = [text dataUsingEncoding:NSUTF8StringEncoding];
    message.type = TMSTextMessage;
    [self sendMessage:message];
    self.textField.text = @"";
}

- (IBAction)sendImage:(id)sender {
    Message *message = [NSEntityDescription insertNewObjectForEntityForName:self.fetchedResultsController.fetchRequest.entityName
                                                     inManagedObjectContext:self.fetchedResultsController.managedObjectContext];
    UIImage *image = [UIImage imageNamed:@"image"];
    message.data = UIImagePNGRepresentation(image);
    message.type = TMSImageMessage;
    [self sendMessage:message];
}

- (IBAction)sendLocation:(id)sender {
    if( !CLLocationManager.locationServicesEnabled || !(CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) ) {
        // Location services are disabled or user has not authorized permissions to use their location.
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Allow Location Access"
                                                                       message:@"Location Services are disabled in Settings. Turn On Location Services and allow the app to determine your location."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    CLLocation *location = self.locationManager.location;
    Message *message = [NSEntityDescription insertNewObjectForEntityForName:self.fetchedResultsController.fetchRequest.entityName
                                                     inManagedObjectContext:self.fetchedResultsController.managedObjectContext];
    message.data = [NSKeyedArchiver archivedDataWithRootObject:location];
    message.type = TMSLocationMessage;
    [self sendMessage:message];
}

- (void)sendMessage:(Message*)message {
    message.date = [NSDate date];
    message.participant = self.speaker;
    [self.conversation addMessagesObject:message];
    [TMSMessagesService.sharedService saveContext];
    [TMSMessagesQueue.sharedQueue insertMessageWithObjectId:message.objectID];
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.controlsBottomConstraint.constant = keyboardSize.height;
    [self animateLayoutForKeyboardNotification:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.controlsBottomConstraint.constant = 0;
    [self animateLayoutForKeyboardNotification:notification];
}

- (void)animateLayoutForKeyboardNotification:(NSNotification *)notification
{
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [UIView setAnimationCurve:curve];
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *message = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self sendText:message];
    return YES;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell<TMSMessageCellSubtitlable> *messageCell;
    switch (message.type) {
        case TMSTextMessage:
        {
            messageCell = [tableView dequeueReusableCellWithIdentifier:kTextCellIdentifier forIndexPath:indexPath];
            ((TMSTextMessageTableViewCell*)messageCell).textMessage = [[NSString alloc] initWithData:message.data encoding:NSUTF8StringEncoding];
            break;
        }
        case TMSImageMessage:
        {
            messageCell = [tableView dequeueReusableCellWithIdentifier:kImageCellIdentifier forIndexPath:indexPath];
            ((TMSImageMessageTableViewCell*)messageCell).image = [UIImage imageWithData:message.data];
            break;
        }
        case TMSLocationMessage:
        {
            messageCell = [tableView dequeueReusableCellWithIdentifier:kLocationCellIdentifier forIndexPath:indexPath];
            ((TMSLocationMessageTableViewCell *)messageCell).pinLocation = (CLLocation *)[NSKeyedUnarchiver unarchiveObjectWithData:message.data];
            break;
        }
        default:
            break;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM.dd hh:mm";
    formatter.locale = [NSLocale currentLocale];
    messageCell.subtitleLabel.text = [NSString stringWithFormat:@"%@ (%@)", message.participant.name,
                                      [formatter stringFromDate:message.date]];
    if (message.participant == self.speaker) {
        messageCell.backgroundColor = [UIColor colorWithRed:(175.0/255.0) green:(228.0/255.0) blue:(114.0/255.0) alpha:1.0];
    } else {
        messageCell.backgroundColor = [UIColor colorWithRed:(175.0/255.0) green:(228.0/255.0) blue:(239.0/255.0) alpha:1.0];
    }
    return messageCell;
}

@end
