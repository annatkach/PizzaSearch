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

@protocol DataManagerProtocol <NSObject>

- (void)dataManagerCompleteLoading;
- (void)dataManagerLoadedAllData;
- (void)dataManagerLoadingFailed;
- (void)dataManagerFailedToGetPosition;
- (void)dataManagerFailedToConnect;

@end

@interface DataManager : NSObject

@property (nonatomic, weak) id<DataManagerProtocol> delegate;

+ (DataManager*)sharedInstance;

- (void)loadPizzaPlaces;

- (NSUInteger)pizzaPlacesCount;

- (PizzaPlace*)pizzaPlaceAtIndexPath:(NSIndexPath*)indexPath;

- (void)setFetchedResultsControllerDelegate:(id<NSFetchedResultsControllerDelegate>)delegate;

@end
