//
//  SpinnerTableViewCell.h
//  PizzaSearch
//
//  Created by Admin on 9/21/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum SpinnerTableViewCellStatus
{
    SpinnerTableViewCellStatusLoading = 0,
    SpinnerTableViewCellStatusAllDataLoaded = 1,
    SpinnerTableViewCellStatusFailureLoading = 2
}SpinnerTableViewCellStatus;

@interface SpinnerTableViewCell : UITableViewCell

- (void)configureWithStatus:(SpinnerTableViewCellStatus)status;

@end
