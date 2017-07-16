//
//  Participant+CoreDataProperties.m
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 14/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import "Participant+CoreDataProperties.h"

@implementation Participant (CoreDataProperties)

+ (NSFetchRequest<Participant *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Participant"];
}

@dynamic isBot;
@dynamic name;
@dynamic conversations;

@end
