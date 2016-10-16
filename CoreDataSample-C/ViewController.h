//
//  ViewController.h
//  CoreDataSample-C
//
//  Created by GengRui on 2016-10-15.
//  Copyright © 2016 GengRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSManagedObjectModel *managedObjectModel;
@property (nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end


