//
//  TMSMessagesService.m
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 12/07/2017.
//  Copyright © 2017 Yulia Shakhavnina. All rights reserved.
//

#import "TMSMessagesService.h"

@implementation TMSMessagesService

+ (instancetype)sharedService
{
    static TMSMessagesService *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TestMessenger" withExtension:@"momd"];
        sharedInstance = [[self alloc] initWithModelFileURL:modelURL storageURL:nil];
    });
    
    return sharedInstance;
}

- (BOOL)addUserWithName:(NSString*)name {
    NSFetchRequest *request = [Participant fetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"name like %@", name];
    NSError *fetchError = nil;
    NSArray *results = [self.mainContext executeFetchRequest:request error:&fetchError];
    if (results.count > 0) {
        // A record with the provided name already exists.
        return NO;
    } else {
        Participant *participantMO = [NSEntityDescription insertNewObjectForEntityForName:request.entityName
                                                                   inManagedObjectContext:self.mainContext];
        participantMO.name = name;
        [self saveContext];
        return YES;
    }
}

- (void)addUserWithName:(NSString*)name inContext:(NSManagedObjectContext*)context {
    NSFetchRequest *request = [Participant fetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"name like %@", name];
    NSError *fetchError = nil;
    NSArray *results = [context executeFetchRequest:request error:&fetchError];
    if (results.count == 0) {
        Participant *participantMO = [NSEntityDescription insertNewObjectForEntityForName:request.entityName
                                                                   inManagedObjectContext:context];
        participantMO.name = name;
        [self saveContext:context];
    }
    [self.mainContext performBlockAndWait:^{
        [self saveContext];
    }];
}

- (Conversation*)newConversationForUser:(Participant*)participant {
    Conversation *conversation = [NSEntityDescription insertNewObjectForEntityForName:[Conversation fetchRequest].entityName
                                                               inManagedObjectContext:self.mainContext];
    conversation.startDate = [NSDate date];
    [conversation addParticipantsObject:participant];
    [self saveContext];
    return conversation;
}

- (void)saveContext {
    [self saveContext:self.mainContext];
}

- (void)saveContext:(NSManagedObjectContext*)context {
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@ %@", error, [error userInfo]);
        abort();
    }
}

@end
