//
//  Conversation+CoreDataProperties.h
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 14/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import "Conversation+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Conversation (CoreDataProperties)

+ (NSFetchRequest<Conversation *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *startDate;
@property (nullable, nonatomic, retain) NSOrderedSet<Message *> *messages;
@property (nullable, nonatomic, retain) NSSet<Participant *> *participants;

@end

@interface Conversation (CoreDataGeneratedAccessors)

- (void)insertObject:(Message *)value inMessagesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMessagesAtIndex:(NSUInteger)idx;
- (void)insertMessages:(NSArray<Message *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMessagesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMessagesAtIndex:(NSUInteger)idx withObject:(Message *)value;
- (void)replaceMessagesAtIndexes:(NSIndexSet *)indexes withMessages:(NSArray<Message *> *)values;
- (void)addMessagesObject:(Message *)value;
- (void)removeMessagesObject:(Message *)value;
- (void)addMessages:(NSOrderedSet<Message *> *)values;
- (void)removeMessages:(NSOrderedSet<Message *> *)values;

- (void)addParticipantsObject:(Participant *)value;
- (void)removeParticipantsObject:(Participant *)value;
- (void)addParticipants:(NSSet<Participant *> *)values;
- (void)removeParticipants:(NSSet<Participant *> *)values;

@end

NS_ASSUME_NONNULL_END
