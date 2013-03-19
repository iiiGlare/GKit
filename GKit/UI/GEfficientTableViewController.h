//
//  GEfficientTableViewController.h
//  GKitDemo
//
//  Created by Hua Cao on 13-3-19.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GTableViewController.h"
#import <CoreData/CoreData.h>

@interface GEfficientTableViewController : GTableViewController
<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *fetchedResultsContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
