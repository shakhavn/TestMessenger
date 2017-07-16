//
//  Message+CoreDataProperties.m
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 14/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import "Message+CoreDataProperties.h"

@implementation Message (CoreDataProperties)

+ (NSFetchRequest<Message *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Message"];
}

@dynamic data;
@dynamic date;
@dynamic type;
@dynamic conversation;
@dynamic participant;

@end
