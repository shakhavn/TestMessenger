//
//  TMSBotUser.h
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 14/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Participant+CoreDataClass.h"

@interface TMSBotUser : NSObject

+ (instancetype)shared;

// Must be called in a block if the context is background
- (Participant*)botUserInContext:(NSManagedObjectContext*)context;

@end
