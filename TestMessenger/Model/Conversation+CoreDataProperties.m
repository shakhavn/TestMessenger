//
//  Conversation+CoreDataProperties.m
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 14/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import "Conversation+CoreDataProperties.h"

@implementation Conversation (CoreDataProperties)

+ (NSFetchRequest<Conversation *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Conversation"];
}

@dynamic startDate;
@dynamic messages;
@dynamic participants;

@end
