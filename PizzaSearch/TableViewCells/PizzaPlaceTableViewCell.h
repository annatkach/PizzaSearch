//
//  PizzaPlaceTableViewCell.h
//  PizzaSearch
//
//  Created by Admin on 9/21/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PizzaPlace;

@interface PizzaPlaceTableViewCell : UITableViewCell

- (void)configureWithPizzaPlace:(PizzaPlace*)pizzaPlace;

@end
