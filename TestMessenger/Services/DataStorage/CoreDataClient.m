//
//  CoreDataClient.m
//
//  Created by Yulia Shakhavnina on 12/07/2017.
//  Copyright © 2017 Yulia Shakhavnina. All rights reserved.
//

#import "CoreDataClient.h"

@interface CoreDataClient ()

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation CoreDataClient

@synthesize managedObjectModel = _managedObjectModel;
@synthesize mainContext = _mainContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize storageURL = _storageURL;

- (instancetype)init {
    NSAssert(NO, @"Use -initWithModelFileURL:storageURL: instead.");
    return nil;
}

- (instancetype)initWithModelFileURL:(NSURL *)modelFileURL storageURL:(NSURL *)storageURL {
    NSParameterAssert(modelFileURL);

    self = [super init];
    if (self)
    {
        _modelFileURL = modelFileURL;
        _storageURL = storageURL;
    }
    return self;
}

- (NSURL *)storageURL {
    if (!_storageURL) {
        NSURL *documentsDirectory = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
        NSURL *directoryURL = [documentsDirectory URLByAppendingPathComponent:[self modelFileName]];
        NSString *directoryPath = directoryURL.path;
        if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
            NSError *error;
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
            if (error != nil) {
                NSLog(@"Error during creating directory for storage: %@", error.debugDescription);
            }
            if (![directoryURL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error]) {
                NSLog(@"Error during setting attribute for storage directory: %@", error.debugDescription);
            }
        }
        _storageURL = [directoryURL URLByAppendingPathComponent:self.modelFileName];
    }
    return _storageURL;
}

- (NSString *)modelFileName {
    return self.modelFileURL.lastPathComponent;
}

- (void)performBackgroundTask:(void (^)(NSManagedObjectContext *))block {
    NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    backgroundContext.parentContext = self.mainContext;
    [backgroundContext performBlock:^{
        block(backgroundContext);
    }];
}

#pragma mark Core Data stack

- (NSManagedObjectContext *)mainContext {
    if (!_mainContext) {
        @synchronized(self) {
            _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            _mainContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
        }
    }
    return _mainContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        @synchronized(self) {
            _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
            NSError *error = nil;
            if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storageURL options:nil error:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        @synchronized(self) {
            _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelFileURL];
        }
    }
    return _managedObjectModel;
}

@end
