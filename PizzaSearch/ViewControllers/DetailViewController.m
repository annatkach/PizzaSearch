//
//  DetailViewController.m
//  PizzaSearch
//
//  Created by Admin on 9/19/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import "DetailViewController.h"
#import "PizzaPlace.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setPizzaPlace:(PizzaPlace *)newPizzaPlace
{
    if (_pizzaPlace!= newPizzaPlace)
    {
        _pizzaPlace = newPizzaPlace;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.pizzaPlace)
    {
        self.detailDescriptionLabel.text = self.pizzaPlace.name;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
