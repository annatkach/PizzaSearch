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

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (nonatomic, weak) IBOutlet UILabel *addressLbl;
@property (nonatomic, weak) IBOutlet UILabel *phoneLbl;
@property (nonatomic, weak) IBOutlet UILabel *checkinsLbl;
@property (nonatomic, weak) IBOutlet UILabel *openUntilLbl;

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
        self.nameLbl.text = self.pizzaPlace.name;
        
        self.addressLbl.text = [NSString stringWithFormat:@"Distance: %@m", self.pizzaPlace.distance];
        self.phoneLbl.text = [NSString stringWithFormat:@"Phone: %@m", self.pizzaPlace.phone];
        self.checkinsLbl.text = [NSString stringWithFormat:@"%@ checkins", self.pizzaPlace.checkinsCount];
        self.openUntilLbl.text = self.pizzaPlace.openUntil;
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
