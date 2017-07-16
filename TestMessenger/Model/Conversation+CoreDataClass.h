//
//  Conversation+CoreDataClass.h
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 14/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Message, Participant;

NS_ASSUME_NONNULL_BEGIN

@interface Conversation : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Conversation+CoreDataProperties.h"
