//
//  MasterViewController.m
//  PizzaSearch
//
//  Created by Admin on 9/19/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import "DataManager.h"
#import "PizzaPlace.h"

#import "SpinnerTableViewCell.h"
#import "PizzaPlaceTableViewCell.h"

#define kPIZZA_PLACE_ROW_HEIGHT 50
#define kSPINNER_ROW_HEIGHT 35

#define kPIZZA_PLACE_CELL_IDENTIFIER @"PIZZA_PLACE_CELL_IDENTIFIER"
#define kSPINNER_CELL_IDENTIFIER @"SPINNER_CELL_IDENTIFIER"

#define kSHOW_DETAIL_SEGUE_IDENTIFIER @"showDetail"

@interface MasterViewController () <DataManagerProtocol>

@property (nonatomic) BOOL loadingMoreTableViewData;
@property (nonatomic) CGPoint tableViewOffset;
@property (nonatomic) SpinnerTableViewCellStatus spinnerStatus;

@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    self.spinnerStatus = SpinnerTableViewCellStatusLoading;
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SpinnerTableViewCell class]) bundle:nil] forCellReuseIdentifier:kSPINNER_CELL_IDENTIFIER];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PizzaPlaceTableViewCell class]) bundle:nil] forCellReuseIdentifier:kPIZZA_PLACE_CELL_IDENTIFIER];
   
    
    [DataManager sharedInstance].delegate = self;
    [[DataManager sharedInstance] setFetchedResultsControllerDelegate:self];
    
    [self loadPizzaPlaces];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPizzaPlaces
{
    if (!self.loadingMoreTableViewData)
    {
        self.loadingMoreTableViewData = YES;
        [[DataManager sharedInstance] performSelector:@selector(loadPizzaPlaces) withObject:nil afterDelay:0.5];
    }
}

- (NSUInteger)pizzaPlacesCount
{
    return [DataManager sharedInstance].pizzaPlacesCount;
}

- (BOOL)isPizzaPlaceCellAtIndexPath:(NSIndexPath*)indexPath
{
    return indexPath.row < [self pizzaPlacesCount];
}

- (BOOL)isSpinnerCellAtIndexPath:(NSIndexPath*)indexPath
{
    return indexPath.row == [self pizzaPlacesCount];
}

- (BOOL)isSpinnerCellVisible
{
    NSArray *indexes = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in indexes)
    {
        if ([self isSpinnerCellAtIndexPath:indexPath])
        {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kSHOW_DETAIL_SEGUE_IDENTIFIER])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PizzaPlace *pizzaPlace = [[DataManager sharedInstance] pizzaPlaceAtIndexPath:indexPath];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.pizzaPlace = pizzaPlace;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self pizzaPlacesCount] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self isPizzaPlaceCellAtIndexPath:indexPath] ? kPIZZA_PLACE_ROW_HEIGHT : kSPINNER_ROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self isPizzaPlaceCellAtIndexPath:indexPath] ? kPIZZA_PLACE_ROW_HEIGHT : kSPINNER_ROW_HEIGHT;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isPizzaPlaceCellAtIndexPath:indexPath])
    {
        PizzaPlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPIZZA_PLACE_CELL_IDENTIFIER forIndexPath:indexPath];
        [self configurePizzaPlaceCell:cell atIndexPath:indexPath];

        return cell;
    }
    else
    {
        SpinnerTableViewCell *spinnerCell = [tableView dequeueReusableCellWithIdentifier:kSPINNER_CELL_IDENTIFIER forIndexPath:indexPath];
        
        [spinnerCell configureWithStatus:self.spinnerStatus];
        
        return spinnerCell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configurePizzaPlaceCell:(PizzaPlaceTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([self isPizzaPlaceCellAtIndexPath:indexPath])
    {
        PizzaPlace *pizzaPlace = [[DataManager sharedInstance] pizzaPlaceAtIndexPath:indexPath];
        [cell configureWithPizzaPlace:pizzaPlace];
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:kSHOW_DETAIL_SEGUE_IDENTIFIER sender:nil];
}

#pragma mark - Fetched results controller Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    self.tableViewOffset = self.tableView.contentOffset;
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    UITableViewRowAnimation animationType = UITableViewRowAnimationNone;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:animationType];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animationType];
            break;
            
        case NSFetchedResultsChangeUpdate:
           [self configurePizzaPlaceCell:(PizzaPlaceTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animationType];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:animationType];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
//    [self.tableView.layer removeAllAnimations];
//    NSLog(@"%f, %f", self.tableViewOffset.y, self.tableView.contentOffset.y);
    
    self.tableView.contentOffset = self.tableViewOffset;
    
    [self.tableView endUpdates];
}


#pragma mark - Table View Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != self.tableView)
    {
        return;
    }
    
    CGFloat actualPosition = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height - scrollView.frame.size.height - kSPINNER_ROW_HEIGHT;
    if (actualPosition >= contentHeight)
    {
        [self loadPizzaPlaces];
    }
}

#pragma mark - DataManager Protocol

- (void)dataManagerCompleteLoading
{
    self.loadingMoreTableViewData = NO;
    
    if ([self isSpinnerCellVisible])
    {
        [self loadPizzaPlaces];
    }
    
    [self configureSpinnerCellWithStatus:SpinnerTableViewCellStatusLoading];
}

- (void)dataManagerLoadedAllData
{
    [self configureSpinnerCellWithStatus:SpinnerTableViewCellStatusAllDataLoaded];
}

- (void)dataManagerLoadingFailed
{
    [self configureSpinnerCellWithStatus:SpinnerTableViewCellStatusFailureLoading];
}

- (void)configureSpinnerCellWithStatus:(SpinnerTableViewCellStatus)status
{
    self.spinnerStatus = status;
    
    SpinnerTableViewCell *cell = (SpinnerTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self pizzaPlacesCount] inSection:0]];
    
    [cell configureWithStatus:self.spinnerStatus];
}
@end
