//
//  Product.h
//  CoreDataSample-C
//
//  Created by Rui Geng on 2016-10-16.
//  Copyright © 2016 GengRui. All rights reserved.
//

#ifndef Product_h
#define Product_h
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface AAAProductMO : NSManagedObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDecimalNumber *price;

@end


#endif /* Product_h */
