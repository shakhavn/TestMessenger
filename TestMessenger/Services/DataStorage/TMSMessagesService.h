//
//  TMSMessagesService.h
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 12/07/2017.
//  Copyright © 2017 Yulia Shakhavnina. All rights reserved.
//

#import "CoreDataClient.h"
#import "Message+CoreDataClass.h"
#import "Conversation+CoreDataClass.h"
#import "Participant+CoreDataClass.h"

@interface TMSMessagesService : CoreDataClient

+ (instancetype)sharedService;

- (BOOL)addUserWithName:(NSString*)name; // <-- done in the main context
- (void)addUserWithName:(NSString*)name inContext:(NSManagedObjectContext*)context;

- (Conversation*)newConversationForUser:(Participant*)participant;

- (void)saveContext;

@end
