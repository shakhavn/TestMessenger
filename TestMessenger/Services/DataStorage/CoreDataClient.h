//
//  CoreDataClient.h
//
//  Created by Yulia Shakhavnina on 12/07/2017.
//  Copyright © 2017 Yulia Shakhavnina. All rights reserved.
//

@import CoreData;

@interface CoreDataClient : NSObject

/**
 Designated initializer.

 @param modelFileURL Path to the *.xcdatamodel (*.momd in runtime) file.
 @param storageURL Path to the directory which will contain CoreData files. If nil then using ~/Documents/_modelFileName_ directory in user domain.
 @return Initialized object.
 */
- (instancetype)initWithModelFileURL:(NSURL *)modelFileURL storageURL:(NSURL *)storageURL NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, strong, readonly) NSURL *modelFileURL;
@property (nonatomic, strong, readonly) NSURL *storageURL;

@property (readonly, strong, nonatomic) NSManagedObjectContext *mainContext;

- (void)performBackgroundTask:(void (^)(NSManagedObjectContext *))block;

@end
