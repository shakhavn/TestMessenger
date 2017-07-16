//
//  TMSBotUser.m
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 14/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import "TMSBotUser.h"
#import "TMSMessagesQueue.h"
#import "TMSMessagesService.h"

@interface TMSBotUser ()

@property (nonatomic) NSManagedObjectID* botObjectId;

@end

@implementation TMSBotUser

+ (instancetype)shared
{
    static TMSBotUser *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(receivedMessageNotification:) name:TMSNewMessageNotification object:nil];
    });
    
    return sharedInstance;
}

- (Participant*)botUserInContext:(NSManagedObjectContext*)context {
    Participant *botUser;
    if (self.botObjectId != nil) {
        botUser = [context objectWithID:self.botObjectId];
        return botUser;
    }
    NSFetchRequest *request = [Participant fetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"isBot = YES"];
    NSError *fetchError = nil;
    NSArray *results = [context executeFetchRequest:request error:&fetchError];
    if (results.count == 1) {
        botUser = results.firstObject;
    } else {
        Participant *participantMO = [NSEntityDescription insertNewObjectForEntityForName:request.entityName
                                                                   inManagedObjectContext:context];
        participantMO.name = @"BOT";
        participantMO.isBot = YES;
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@ %@", error, [error userInfo]);
            abort();
        }
        botUser = participantMO;
    }
    self.botObjectId = botUser.objectID;
    return botUser;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)receivedMessageNotification:(NSNotification*)notification {
    NSManagedObjectID* objectId = [notification object];
    [TMSMessagesService.sharedService performBackgroundTask:^(NSManagedObjectContext *context) {
        sleep(1); // <-- simulate a delay in answer
        Message *receivedMessage = [context objectWithID:objectId];
        Message *reply = [NSEntityDescription insertNewObjectForEntityForName:objectId.entity.name
                                                       inManagedObjectContext:context];
        reply.data = receivedMessage.data;
        reply.type = receivedMessage.type;
        reply.date = [NSDate date];
        reply.participant = [self botUserInContext:context];
        reply.conversation = receivedMessage.conversation;
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@ %@", error, [error userInfo]);
            abort();
        }
        [TMSMessagesService.sharedService saveContext];
        // Don't send it to TMSMessagesQueue. Otherwise, we will get a notification about it...
    }];
}

@end
