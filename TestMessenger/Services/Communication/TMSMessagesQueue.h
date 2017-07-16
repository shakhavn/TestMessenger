//
//  TMSMessagesQueue.h
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 14/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString* const TMSNewMessageNotification;

@interface TMSMessagesQueue : NSObject

+ (instancetype)sharedQueue;

- (void)insertMessageWithObjectId:(NSManagedObjectID*)objectIdf;

@end
