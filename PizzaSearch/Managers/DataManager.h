//
//  DownloadManager.h
//  PizzaSearch
//
//  Created by Admin on 9/20/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PizzaPlace;
@protocol NSFetchedResultsControllerDelegate;


@interface DataManager : NSObject

+ (DataManager*)sharedInstance;

- (void)loadPizzaPlaces;

- (NSUInteger)pizzaPlacesCount;

- (PizzaPlace*)pizzaPlaceAtIndexPath:(NSIndexPath*)indexPath;

- (void)setFetchedResultsControllerDelegate:(id<NSFetchedResultsControllerDelegate>)delegate;

@end
