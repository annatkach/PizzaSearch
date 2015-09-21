//
//  DownloadManager.m
//  PizzaSearch
//
//  Created by Admin on 9/20/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import "DataManager.h"

#import <RestKit/RestKit.h>

#import "Group.h"
#import "Item.h"

#define kFOURSQUARE_CLIENT_ID @"ODP3WHEFWHF1LL4CCN5LDIIMSZUK5IEIIY4WOICOZTMVXKTK"
#define kFOURSQUARE_CLIENT_SECRET @"NGCGORWOOMPBKYJEXCOODSJXRCILSQERJGDDITAV2PL5ENUC"
#define kFOURSQUARE_VERSION @"20150920"

#define kFOURSQUARE_API_BASE_URL @"https://api.foursquare.com"
#define kFOURSQUARE_API_SEARCH_URL @"/v2/venues/explore"
#define kFOURSQUARE_VENUES_KEY_PATH @"response.groups"

#define kFOURSQUARE_EXPLORE_LIMIT 10
#define kFOURSQUARE_CATEGORY_ID @"4bf58dd8d48988d1ca941735"

@interface DataManager ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation DataManager

#pragma mark - Shared Instance & Initialization

+ (DataManager*)sharedInstance
{
    static DataManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^()
                  {
                      sharedInstance = [DataManager new];
                  });
    
    return sharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        [self configureRestKit];
        [self setupFetchedResultsController];
    }
    
    return self;
}

#pragma mark - RESTKit configuration

- (void)configureRestKit
{
    // Initialize RestKit
    NSURL *baseURL = [NSURL URLWithString:kFOURSQUARE_API_BASE_URL];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    // Core Data stack initialization
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"PizzaPlacesDB.sqlite"];
    NSString *seedPath = [[NSBundle mainBundle] pathForResource:@"RKSeedDatabase" ofType:@"sqlite"];
    NSError *error;
    
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:seedPath withConfiguration:nil options:nil error:&error];
    
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
    RKResponseDescriptor *modelResponseDescriptor =
                [RKResponseDescriptor
                 responseDescriptorWithMapping:[self modelMappingWithManagedObjectStore:managedObjectStore]
                                        method:RKRequestMethodGET
                                   pathPattern:kFOURSQUARE_API_SEARCH_URL
                                       keyPath:kFOURSQUARE_VENUES_KEY_PATH
                                statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:modelResponseDescriptor];
}

- (RKObjectMapping*)modelMappingWithManagedObjectStore:(RKManagedObjectStore*)managedObjectStore
{
    RKObjectMapping *groupMapping = [RKObjectMapping mappingForClass:[Group class]];
 
    RKObjectMapping *itemMapping = [RKObjectMapping mappingForClass:[Item class]];
   
    RKRelationshipMapping *itemRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:@"items" toKeyPath:@"items" withMapping:itemMapping];
    [groupMapping addPropertyMapping:itemRelationship];
    
    
    RKEntityMapping *pizzaPlaceMapping = [RKEntityMapping mappingForEntityForName:@"PizzaPlace" inManagedObjectStore:managedObjectStore];
    [pizzaPlaceMapping addAttributeMappingsFromDictionary:
                                                    @{
                                                       @"name":@"name",
                                                       @"id" : @"placeId",
                                                       @"location.distance" : @"distance"
                                                     }];
    pizzaPlaceMapping.identificationAttributes = @[@"placeId"];
    RKRelationshipMapping *pizzaPlaceRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:@"venue" toKeyPath:@"pizzaPlace" withMapping:pizzaPlaceMapping];
    [itemMapping addPropertyMapping:pizzaPlaceRelationship];

    return groupMapping;
}

#pragma mark - PizzaPlaces 

- (void)loadPizzaPlaces
{
    NSString *latLon = @"40.7029741,-74.2598672";
    
    NSDictionary *queryParams = @{@"ll" : latLon,
                                  @"client_id" : kFOURSQUARE_CLIENT_ID,
                                  @"client_secret" : kFOURSQUARE_CLIENT_SECRET,
                                  @"categoryId" : kFOURSQUARE_CATEGORY_ID,
                                  @"v" : kFOURSQUARE_VERSION,
                                  @"limit" : [NSNumber numberWithInt:kFOURSQUARE_EXPLORE_LIMIT]
                                  };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:kFOURSQUARE_API_SEARCH_URL
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                              {
                                                  [self saveData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error)
                                              {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
}

- (NSUInteger)pizzaPlacesCount
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
    return [sectionInfo numberOfObjects];
}

- (PizzaPlace*)pizzaPlaceAtIndexPath:(NSIndexPath*)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return (PizzaPlace*)object;
}

- (void)saveData
{
    NSError *error = nil;
    [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext saveToPersistentStore:&error];
}

#pragma mark - FetchedResultsController

- (void)setupFetchedResultsController
{
    NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"PizzaPlace"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
    fetchRequest.sortDescriptors = @[descriptor];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"PizzaPlaceCache"];
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)setFetchedResultsControllerDelegate:(id<NSFetchedResultsControllerDelegate>)delegate
{
    self.fetchedResultsController.delegate = delegate;
}

@end
