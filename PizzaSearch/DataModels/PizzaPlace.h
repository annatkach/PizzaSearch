//
//  PizzaPlace.h
//  PizzaSearch
//
//  Created by Admin on 9/20/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PizzaPlace : NSManagedObject

@property (nonatomic, retain) NSString * placeId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * distance;

@end
