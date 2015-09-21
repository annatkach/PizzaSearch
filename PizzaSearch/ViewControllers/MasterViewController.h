//
//  MasterViewController.h
//  PizzaSearch
//
//  Created by Admin on 9/19/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@end

