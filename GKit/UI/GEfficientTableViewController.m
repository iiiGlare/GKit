//
//  GEfficientTableViewController.m
//  GKitDemo
//
//  Created by Hua Cao on 13-3-19.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GEfficientTableViewController.h"
#import "GCore.h"
#import "GCoreData.h"

@implementation GEfficientTableViewController
#pragma mark - Init && Memory
- (void)customInitialize
{
	self.fetchedResultsContext = [GCoreData newContextWithConcurrencyType:NSPrivateQueueConcurrencyType];
}

#pragma mark - Action
- (void)reloadData
{
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		GPRINTError(error);
		exit(-1);
	}
	[self.tableView reloadData];
}

#pragma mark - Table View

//UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger count = [[_fetchedResultsController sections] count];
	return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	id<NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	id<NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo name];
}

//UITableViewDelegate

#pragma mark - Fetched Results Controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
	UITableView *tableView = self.tableView;
	
	switch (type) {
		case NSFetchedResultsChangeInsert:
			
			[tableView insertRowsAtIndexPaths: @[newIndexPath]
							 withRowAnimation: UITableViewRowAnimationNone];
			break;
		case NSFetchedResultsChangeDelete:
			
			[tableView deleteRowsAtIndexPaths: @[indexPath]
							 withRowAnimation: UITableViewRowAnimationNone];
			break;
		case NSFetchedResultsChangeUpdate:
			
			[self configureCell: [tableView cellForRowAtIndexPath:indexPath]
					atIndexPath: indexPath];
			break;
		case NSFetchedResultsChangeMove:
			
			[tableView deleteRowsAtIndexPaths: @[indexPath]
							 withRowAnimation: UITableViewRowAnimationNone];
			[tableView insertRowsAtIndexPaths: @[newIndexPath]
							 withRowAnimation: UITableViewRowAnimationNone];
			break;
		default:
			break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
	UITableView *tableView = self.tableView;
	
	switch (type) {
		case NSFetchedResultsChangeInsert:
			
			[tableView insertSections: [NSIndexSet indexSetWithIndex:sectionIndex]
					 withRowAnimation: UITableViewRowAnimationNone];
			break;
		case NSFetchedResultsChangeDelete:
			
			[tableView deleteSections: [NSIndexSet indexSetWithIndex:sectionIndex]
					 withRowAnimation: UITableViewRowAnimationNone];
			break;
		default:
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	[self.tableView endUpdates];
}

@end
