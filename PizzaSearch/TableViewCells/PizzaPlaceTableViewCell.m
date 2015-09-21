//
//  PizzaPlaceTableViewCell.m
//  PizzaSearch
//
//  Created by Admin on 9/21/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import "PizzaPlaceTableViewCell.h"

#import "PizzaPlace.h"

@interface PizzaPlaceTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel* nameLbl;
@property (nonatomic, weak) IBOutlet UILabel* distanceLbl;

@end

@implementation PizzaPlaceTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithPizzaPlace:(PizzaPlace*)pizzaPlace
{
    self.nameLbl.text = pizzaPlace.name;
    self.distanceLbl.text = [NSString stringWithFormat:@"%@m", pizzaPlace.distance];
}

@end
