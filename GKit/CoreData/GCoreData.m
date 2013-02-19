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

@implementation GCoreData

@synthesize managedObjectContext = _managedObjectContext;
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

#pragma mark - 
//save
+ (void)save
{
    [self saveInManagedObjectContext:[[GCoreData sharedInstance] managedObjectContext]];
}
+ (void)saveInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSError *error;
    if (![context save:&error]) {
        // Update to handle the error appropriately.
        GLOG(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
}

//del
+ (void)deleteObject:(id)objectToDelete
{
	NSManagedObjectContext *context = [[GCoreData sharedInstance] managedObjectContext];
	
	if ([objectToDelete isKindOfClass:[NSManagedObject class]]){	//删除单个
		[context deleteObject:objectToDelete];
	}else if ([objectToDelete isKindOfClass:[NSArray class]]){	//删除多个
		[(NSArray *)objectToDelete enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
			[context deleteObject:obj];
		}];
	}else if ([objectToDelete isKindOfClass:[NSSet class]]){	//删除多个
		[(NSSet *)objectToDelete enumerateObjectsUsingBlock:^(id obj, BOOL *stop){
			[context deleteObject:obj];
		}];
	}else {
		return;
	}
	
	// Commit the change.
	NSError *error = nil;
	if (![context save:&error]) {
		// Handle the error.
	}
}

//new
+ (id)insertNewForEntityNamed:(NSString *)entityName
{
    return [GCoreData insertNewForEntityNamed:entityName
                       inManagedObjectContext:[[GCoreData sharedInstance] managedObjectContext]];
}
+ (id)insertNewForEntityNamed:(NSString *)entityName inManagedObjectContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext:context];
}

//fetch
//fetch first object for entity
+ (id)fetchFirstForEntityName:(NSString *)entityName
          withSortDescriptors:(NSArray *)dess
{

    NSArray *fetchResults = [GCoreData fetchAllForEntityName:entityName
                                         withSortDescriptors:dess
                                              withFetchLimit:1];
    return [fetchResults firstObject];

}
+ (NSArray *)fetchAllForEntityName:(NSString *)entityName
               withSortDescriptors:(NSArray *)dess
{
    return [GCoreData fetchAllForEntityName:entityName
                        withSortDescriptors:dess
                             withFetchLimit:0];
}
+ (NSArray *)fetchAllForEntityName:(NSString *)entityName
               withSortDescriptors:(NSArray *)dess
                    withFetchLimit:(NSUInteger)limit
{
    NSManagedObjectContext *context = [[GCoreData sharedInstance] managedObjectContext];
    //create fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [request setEntity:entity];
    [request setFetchLimit:limit];
    [request setSortDescriptors:dess];
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil)
    {
        // Handle the error.
    }
    return mutableFetchResults;
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
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
