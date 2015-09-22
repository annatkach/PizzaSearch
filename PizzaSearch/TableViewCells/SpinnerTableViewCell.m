//
//  SpinnerTableViewCell.m
//  PizzaSearch
//
//  Created by Admin on 9/21/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import "SpinnerTableViewCell.h"

@interface SpinnerTableViewCell ()

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet UILabel *messageLbl;

@end

@implementation SpinnerTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureAllDataLoadedStatus
{
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    self.messageLbl.text = @"All data loaded";
}

- (void)configureLoadingStatus
{
    self.activityIndicator.hidden = NO;
    self.messageLbl.text = @"";
    [self.activityIndicator startAnimating];
}

- (void)configureFailureStatus
{
    self.activityIndicator.hidden = YES;
    self.messageLbl.text = @"Loading failed";
    [self.activityIndicator stopAnimating];
}

- (void)configureFailedToGetLocationStatus
{
    self.activityIndicator.hidden = YES;
    self.messageLbl.text = @"Can not get a location";
    [self.activityIndicator stopAnimating];
}

- (void)configureWithNoInterntConnectionStatus
{
    self.activityIndicator.hidden = YES;
    self.messageLbl.text = @"No internet connection";
    [self.activityIndicator stopAnimating];
}

- (void)configureWithStatus:(SpinnerTableViewCellStatus)status
{
    switch (status) {
        case SpinnerTableViewCellStatusLoading:
            [self configureLoadingStatus];
            break;
            
        case SpinnerTableViewCellStatusAllDataLoaded:
            [self configureAllDataLoadedStatus];
            break;
            
        case SpinnerTableViewCellStatusFailureLoading:
           [self configureFailureStatus];
            break;
            
        case SpinnerTableViewCellStatusFailedToGetLocation:
            [self configureFailedToGetLocationStatus];
            break;
            
        case SpinnerTableViewCellStatusNoInternetConnection:
            [self configureWithNoInterntConnectionStatus];
            break;
    }
}

@end
