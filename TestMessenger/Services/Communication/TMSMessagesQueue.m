//
//  TMSMessagesQueue.m
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 14/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import "TMSMessagesQueue.h"

NSString* _Nonnull const TMSNewMessageNotification = @"TMSNewMessageNotification";

@implementation TMSMessagesQueue

+ (instancetype)sharedQueue
{
    static TMSMessagesQueue *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)insertMessageWithObjectId:(NSManagedObjectID*)objectId {
    // Test Implementation : no server side. Just fire the notification to inform all interested parties
    [[NSNotificationCenter defaultCenter] postNotificationName:TMSNewMessageNotification object:objectId];
}

@end
