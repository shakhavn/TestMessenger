//
//  Message+CoreDataProperties.h
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 14/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import "Message+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

typedef enum : int64_t {
    TMSTextMessage = 0,
    TMSImageMessage,
    TMSLocationMessage
} TMSMessageType;

@interface Message (CoreDataProperties)

+ (NSFetchRequest<Message *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *data;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nonatomic) TMSMessageType type;
@property (nullable, nonatomic, retain) Conversation *conversation;
@property (nullable, nonatomic, retain) Participant *participant;

@end

NS_ASSUME_NONNULL_END
