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

#import <CoreData/CoreData.h>
#import "NSArray+GCoreData.h"
#import "NSSet+GCoreData.h"
#import "NSManagedObject+GCoreData.h"
#import "NSManagedObjectContext+GCoreData.h"
#import "NSFetchedResultsController+GCoreData.h"

@interface GCoreData : NSObject

/**
 setup
 */
+ (BOOL) setupWithName:(NSString *)name;
+ (BOOL) setupWithModelName:(NSString *)modelName
                  storeName:(NSString *)storeName;


/**
 */
+ (id) sharedInstance;

@property (nonatomic, copy) NSString * modelName;
@property (nonatomic, copy) NSString * storeName;

/**
 */
@property (readonly, strong, nonatomic) NSManagedObjectContext * mainContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel * managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator * persistentStoreCoordinator;


//create new context
enum {
    GConcurrencyTypeConfinement			= NSConfinementConcurrencyType,
    GConcurrencyTypePrivateQueue		= NSPrivateQueueConcurrencyType,
    GConcurrencyTypeMainQueue			= NSMainQueueConcurrencyType
};
typedef NSUInteger GConcurrencyType;

+ (NSManagedObjectContext *) newContext;
+ (NSManagedObjectContext *) newContextWithConcurrencyType:(GConcurrencyType)type;

//save
+ (void) saveObject: (id)object;

//del
+ (void) deleteObject: (id)object;

//new
+ (id) insertNewForEntityNamed: (NSString *)entityName;
+ (id) insertNewForEntityNamed: (NSString *)entityName
                     inContext: (NSManagedObjectContext *)context;

//fetch
//fetch first
+ (id) findFirstForEntityName: (NSString *)entityName;
+ (id) findFirstForEntityName: (NSString *)entityName
					inContext: (NSManagedObjectContext *)context;
//fetch first : predicate
+ (id) findFirstForEntityName: (NSString *)entityName
				withPredicate: (NSPredicate *)predicate;
+ (id) findFirstForEntityName: (NSString *)entityName
				withPredicate: (NSPredicate *)predicate
					inContext: (NSManagedObjectContext *)context;


//fetch all
+ (NSArray *) findAllForEntityName: (NSString *)entityName;
+ (NSArray *) findAllForEntityName: (NSString *)entityName
						 inContext: (NSManagedObjectContext *)context;
//fetch all : predicate
+ (NSArray *) findAllForEntityName:(NSString *)entityName
					 withPredicate:(NSPredicate *)predicate;
+ (NSArray *) findAllForEntityName:(NSString *)entityName
					 withPredicate:(NSPredicate *)predicate
						 inContext:(NSManagedObjectContext *)context;

//fetch all : predicate 、sort
+ (NSArray *) findAllForEntityName: (NSString *)entityName
					 withPredicate: (NSPredicate *)predicate
						 sortByKey: (NSString *)key
						 ascending: (NSNumber *)ascending;
+ (NSArray *) findAllForEntityName: (NSString *)entityName
					 withPredicate: (NSPredicate *)predicate
						 sortByKey: (NSString *)key
						 ascending: (NSNumber *)ascending
						 inContext: (NSManagedObjectContext *)context;

+ (NSArray *) findAllForEntityName: (NSString *)entityName
					 withPredicate: (NSPredicate *)predicate
						sortByKeys: (NSArray *)keys
						ascendings: (NSArray *)ascendings;
+ (NSArray *) findAllForEntityName: (NSString *)entityName
					 withPredicate: (NSPredicate *)predicate
						sortByKeys: (NSArray *)keys
						ascendings: (NSArray *)ascendings
						 inContext: (NSManagedObjectContext *)context;

//fetch all : predicate 、sort、limit
+ (NSArray *) findAllForEntityName: (NSString *)entityName
					 withPredicate: (NSPredicate *)predicate
						sortByKeys: (NSArray *)keys
						ascendings: (NSArray *)ascendings
						 limitedTo: (NSUInteger)limitNumber;
+ (NSArray *) findAllForEntityName: (NSString *)entityName
					 withPredicate: (NSPredicate *)predicate
						sortByKeys: (NSArray *)keys
						ascendings: (NSArray *)ascendings
						 limitedTo: (NSUInteger)limitNumber
						 inContext: (NSManagedObjectContext *)context;

//fetch all : fetch results controller
+ (NSFetchedResultsController *) fetchedResultsForEntityName: (NSString *)entityName
                                                withDelegate: (id<NSFetchedResultsControllerDelegate>)delegate
                                                   predicate: (NSPredicate *)predicate
                                                  sortByKeys: (NSArray *)keys
                                                  ascendings: (NSArray *)ascendings
                                                   groupedBy: (NSString *)groupKeyPath
                                                   cacheName: (NSString *)cacheName;
+ (NSFetchedResultsController *) fetchedResultsForEntityName: (NSString *)entityName
                                                withDelegate: (id<NSFetchedResultsControllerDelegate>)delegate
                                                   predicate: (NSPredicate *)predicate
                                                  sortByKeys: (NSArray *)keys
                                                  ascendings: (NSArray *)ascendings
                                                   groupedBy: (NSString *)groupKeyPath
                                                   cacheName: (NSString *)cacheName
                                                   inContext: (NSManagedObjectContext *)context;

@end