//
//  Participant+CoreDataProperties.h
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 14/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import "Participant+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Participant (CoreDataProperties)

+ (NSFetchRequest<Participant *> *)fetchRequest;

@property (nonatomic) BOOL isBot;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSOrderedSet<Conversation *> *conversations;

@end

@interface Participant (CoreDataGeneratedAccessors)

- (void)insertObject:(Conversation *)value inConversationsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromConversationsAtIndex:(NSUInteger)idx;
- (void)insertConversations:(NSArray<Conversation *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeConversationsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInConversationsAtIndex:(NSUInteger)idx withObject:(Conversation *)value;
- (void)replaceConversationsAtIndexes:(NSIndexSet *)indexes withConversations:(NSArray<Conversation *> *)values;
- (void)addConversationsObject:(Conversation *)value;
- (void)removeConversationsObject:(Conversation *)value;
- (void)addConversations:(NSOrderedSet<Conversation *> *)values;
- (void)removeConversations:(NSOrderedSet<Conversation *> *)values;

@end

NS_ASSUME_NONNULL_END
