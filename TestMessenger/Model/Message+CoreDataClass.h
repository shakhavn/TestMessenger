//
//  Message+CoreDataClass.h
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 14/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conversation, Participant;

NS_ASSUME_NONNULL_BEGIN

@interface Message : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Message+CoreDataProperties.h"
