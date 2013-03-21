//
// Created by Cao Hua <glare.ch@gmail.com> on 2012
// Copyright 2012 GKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "GCoreData.h"
#import "GCore.h"

@implementation GCoreData

@synthesize mainContext = _mainContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Init
+ (BOOL)setupWithName:(NSString *)name
{
    return [self setupWithModelName:name storeName:name];
}

+ (BOOL)setupWithModelName:(NSString *)modelName storeName:(NSString *)storeName
{
    GCoreData *coreData = [GCoreData sharedInstance];
    coreData.modelName = modelName;
    coreData.storeName = storeName;
    return YES;
}

+ (id)sharedInstance
{
    static GCoreData *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[GCoreData alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Context
//create new context
+ (NSManagedObjectContext *)newContext
{
	return [GCoreData newContextWithConcurrencyType:GConcurrencyTypeConfinement];
}
+ (NSManagedObjectContext *) newContextWithConcurrencyType:(GConcurrencyType)type;
{
	NSPersistentStoreCoordinator *coordinator = [[GCoreData sharedInstance] persistentStoreCoordinator];
    GASSERT(coordinator!=nil);
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
    [context setPersistentStoreCoordinator:coordinator];
    return context;
}

+ (NSManagedObjectContext *)mainContext
{
    return [[GCoreData sharedInstance] mainContext];
}

NSManagedObjectContext * MainContext(void)
{
    return [GCoreData mainContext];
}

#pragma mark - 
//save
+ (void) saveObject: (id)object
{
	if ([object respondsToSelector:@selector(saveToStore)]) {
		[object saveToStore];
	}
}

//del
+ (void)deleteObject:(id)object
{
	if ([object respondsToSelector:@selector(deleteFromStore)]) {
		[object deleteFromStore];
	}
}

//new
+ (id)insertNewForEntityNamed:(NSString *)entityName
{
    return [GCoreData insertNewForEntityNamed: entityName
									inContext: MainContext()];
}
+ (id)insertNewForEntityNamed:(NSString *)entityName
                    inContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName: entityName
                                         inManagedObjectContext: context];
}

//fetch
//fetch first object
+ (id) findFirstForEntityName:(NSString *)entityName
{
    return [GCoreData findFirstForEntityName: entityName
								   inContext: MainContext()];
}
+ (id) findFirstForEntityName:(NSString *)entityName
					inContext:(NSManagedObjectContext *)context;
{
    return [GCoreData findFirstForEntityName: entityName
							   withPredicate: nil
								   inContext: context];
}


+ (id) findFirstForEntityName:(NSString *)entityName
				withPredicate:(NSPredicate *)predicate
{
    return [GCoreData findFirstForEntityName: entityName
							   withPredicate: predicate
								   inContext: MainContext()];

}
+ (id) findFirstForEntityName:(NSString *)entityName
				withPredicate:(NSPredicate *)predicate
					inContext:(NSManagedObjectContext *)context
{
    NSArray *objects = [GCoreData findAllForEntityName: entityName
										 withPredicate: predicate
											sortByKeys: nil
											ascendings: nil
											 limitedTo: 1
											 inContext:context];
    return [objects firstObject];
}

//fetch all
+ (NSArray *) findAllForEntityName:(NSString *)entityName
{
    return [GCoreData findAllForEntityName: entityName
								 inContext: MainContext()];
}
+ (NSArray *) findAllForEntityName:(NSString *)entityName
						 inContext:(NSManagedObjectContext *)context
{
    return [GCoreData findAllForEntityName: entityName
							 withPredicate: nil
								 inContext: context];
}

//fetch all : predicate
+ (NSArray *) findAllForEntityName:(NSString *)entityName
					 withPredicate:(NSPredicate *)predicate
{
    return [GCoreData findAllForEntityName: entityName
							 withPredicate: predicate
								 inContext: MainContext()];
}
+ (NSArray *) findAllForEntityName:(NSString *)entityName
					 withPredicate:(NSPredicate *)predicate
						 inContext:(NSManagedObjectContext *)context
{
    return [GCoreData findAllForEntityName: entityName
							 withPredicate: predicate
								 sortByKey: nil
								 ascending: nil
								 inContext: context];
}

//fetch all : predicate 、sort
+ (NSArray *) findAllForEntityName:(NSString *)entityName
					 withPredicate:(NSPredicate *)predicate
						 sortByKey:(NSString *)key
						 ascending:(NSNumber *)ascending
{
    return [GCoreData findAllForEntityName: entityName
							 withPredicate: predicate
								 sortByKey: key
								 ascending: ascending
								 inContext: MainContext()];
}
+ (NSArray *) findAllForEntityName:(NSString *)entityName
					 withPredicate:(NSPredicate *)predicate
						 sortByKey:(NSString *)key
						 ascending:(NSNumber *)ascending
						 inContext:(NSManagedObjectContext *)context
{
    NSArray *keys = nil;
    NSArray *ascendings = nil;
    if (key && ascending) {
        keys = @[key];
        ascendings = @[ascending];
    }
    return [GCoreData findAllForEntityName: entityName
							 withPredicate: predicate
								sortByKeys: keys
								ascendings: ascendings
								 inContext: context];
}


+ (NSArray *) findAllForEntityName:(NSString *)entityName
					 withPredicate:(NSPredicate *)predicate
						sortByKeys:(NSArray *)keys
						ascendings:(NSArray *)ascendings
{
    return [GCoreData findAllForEntityName: entityName
							 withPredicate: predicate
								sortByKeys: keys
								ascendings: ascendings
								 inContext: MainContext()];
}
+ (NSArray *) findAllForEntityName:(NSString *)entityName
					 withPredicate:(NSPredicate *)predicate
						sortByKeys:(NSArray *)keys
						ascendings:(NSArray *)ascendings
						 inContext:(NSManagedObjectContext *)context
{
    return [GCoreData findAllForEntityName: entityName
							 withPredicate: predicate
								sortByKeys: keys
								ascendings: ascendings
								 limitedTo: 0
								 inContext: context];
}

//fetch all : predicate 、sort、limit
+ (NSArray *) findAllForEntityName:(NSString *)entityName
					 withPredicate:(NSPredicate *)predicate
						sortByKeys:(NSArray *)keys
						ascendings:(NSArray *)ascendings
						 limitedTo:(NSUInteger)limitNumber
{
    return [GCoreData findAllForEntityName: entityName
							 withPredicate: predicate
								sortByKeys: keys
								ascendings: ascendings
								 limitedTo: limitNumber
								 inContext: MainContext()];
}
+ (NSArray *) findAllForEntityName:(NSString *)entityName
					 withPredicate:(NSPredicate *)predicate
						sortByKeys:(NSArray *)keys
						ascendings:(NSArray *)ascendings
						 limitedTo:(NSUInteger)limitNumber
						 inContext:(NSManagedObjectContext *)context
{
    //create fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:context];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSMutableArray *dess = nil;
    if (keys) {
        dess = [[NSMutableArray alloc] init];
        GASSERT([keys count]==[ascendings count]);
        NSInteger number = [keys count];
        for (NSInteger i=0; i<number; i++) {
            NSString *key = [keys objectAtIndex:i];
            BOOL ascending = [[ascendings objectAtIndex:i] boolValue];
            NSSortDescriptor *sortDes = [[NSSortDescriptor alloc] initWithKey:key
                                                                    ascending:ascending];
            [dess addObject:sortDes];
        }
    }
    [request setSortDescriptors:dess];
    [request setFetchLimit:limitNumber];
    //fetch
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil)
    {
        // Handle the error.
    }
    return mutableFetchResults;
}

//fetch all : fetch results controller
+ (NSFetchedResultsController *) fetchedResultsForEntityName:(NSString *)entityName
                                                withDelegate:(id<NSFetchedResultsControllerDelegate>)delegate
                                                   predicate:(NSPredicate *)predicate
                                                  sortByKeys:(NSArray *)keys
                                                  ascendings:(NSArray *)ascendings
                                                   groupedBy:(NSString *)groupKeyPath
                                                   cacheName:(NSString *)cacheName
{
    return [GCoreData fetchedResultsForEntityName: entityName
                                     withDelegate: delegate
                                        predicate: predicate
                                       sortByKeys: keys
                                       ascendings: ascendings
                                        groupedBy: groupKeyPath
                                        cacheName: cacheName
                                        inContext: MainContext()];
}
+ (NSFetchedResultsController *) fetchedResultsForEntityName:(NSString *)entityName
                                                withDelegate:(id<NSFetchedResultsControllerDelegate>)delegate
                                                   predicate:(NSPredicate *)predicate
                                                  sortByKeys:(NSArray *)keys
                                                  ascendings:(NSArray *)ascendings
                                                   groupedBy:(NSString *)groupKeyPath
                                                   cacheName:(NSString *)cacheName
                                                   inContext:(NSManagedObjectContext *)context
{
   
    // Create and configure a fetch request with the given entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName: entityName
                                              inManagedObjectContext: context];
    [fetchRequest setEntity:entity];
    
	// set the Predicate
	[fetchRequest setPredicate:predicate];
	
    // Create the sort descriptors array.
    NSMutableArray *dess = nil;
    if (keys) {
        dess = [[NSMutableArray alloc] init];
        GASSERT([keys count]==[ascendings count]);
        NSInteger number = [keys count];
        for (NSInteger i=0; i<number; i++) {
            NSString *key = [keys objectAtIndex:i];
            BOOL ascending = [[ascendings objectAtIndex:i] boolValue];
            NSSortDescriptor *sortDes = [[NSSortDescriptor alloc] initWithKey:key
                                                                    ascending:ascending];
            [dess addObject:sortDes];
        }
    }
    [fetchRequest setSortDescriptors:dess];
    
    // Create and initialize the fetch results controller.
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:context
                                          sectionNameKeyPath:groupKeyPath
                                                   cacheName:cacheName];
    aFetchedResultsController.delegate = delegate;
    
    return aFetchedResultsController;
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)mainContext
{
    if (_mainContext != nil) {
        return _mainContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _mainContext = [[NSManagedObjectContext alloc] init];
        [_mainContext setPersistentStoreCoordinator:coordinator];
    }
    return _mainContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    GASSERT(self.modelName.length>0);
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.modelName
                                              withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    GASSERT(self.storeName.length>0);
    NSURL *storeURL = [GDocumentsDirectoryURL() URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",self.storeName]];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        GLOG(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

@end
