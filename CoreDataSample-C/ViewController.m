//
//  ViewController.m
//  CoreDataSample-C
//
//  Created by GengRui on 2016-10-15.
//  Copyright © 2016 GengRui. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Product.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self saveProduct:@"iPhone 6S" price:[NSDecimalNumber decimalNumberWithString:@"15.99"]];
    [self showProduct];
    
    [self editProduct:@"iPhone 6S" price:[NSDecimalNumber decimalNumberWithString:@"1599.99"]];
    [self showProduct];
    
    [self delteProduct:@"iPhone 6S"];
    [self showProduct];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveProduct :(NSString *)name price:(NSDecimalNumber*)price {
    
    // Create the NSEntityDescription
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
    
    // Creates an instance of the class for the NSEntityDescription
    AAAProductMO *product = [[AAAProductMO alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    
    product.name = name;
    product.price = price;
    
    [self.managedObjectContext insertObject:product];
    
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    
    if (error != nil) {
        NSLog(@"Save Product Failed: %@", error);
    }
    else {
        NSLog(@"Product Saved.");
    }
}

- (void)showProduct {
    
    // Create the request
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Product"];
    
    NSError *error = nil;
    
    // Search all Products
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error != nil) {
        NSLog(@"Failed: %@", error);
    }
    else {
        NSLog(@"Product Count = %lu", (unsigned long)results.count);
        for(AAAProductMO *product in results) {
            NSLog(@"Product name = %@", product.name);
            NSLog(@"Product price = %@", product.price);
        }
    }
}

- (void)editProduct :(NSString *)name price:(NSDecimalNumber*)price {
    
    // Create the request
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Product"];
    
    // Build the predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    request.predicate = predicate;
    
    // Define sorting
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortDesc];
    
    // Use request search
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error != nil) {
        NSLog(@"Failed: %@", error);
    }
    else {
        NSLog(@"Product Count = %lu", (unsigned long)results.count);
        
        //Loop all product results
        for(AAAProductMO *product in results) {
            product.price = price;
        }
        
        //Save product
        [self.managedObjectContext save:&error];
        if (error != nil) {
            NSLog(@"Edit Product Failed: %@", error);
        }
        else {
            NSLog(@"Product Edited.");
        }
    }
}

- (void)delteProduct :(NSString *)name  {
    
    // Create the request
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Product"];
    
    // Build the predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    request.predicate = predicate;
    
    // Define sorting
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortDesc];
    
    // Use request search
    NSError *error = nil ;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error != nil) {
        NSLog(@"Failed: %@", error);
    }
    else {
        NSLog(@"Product Count = %lu", (unsigned long)results.count);
        
        //Loop all product results
        for(AAAProductMO *product in results) {
            [self.managedObjectContext deleteObject:product];
        }
        
        //Save Context
        [self.managedObjectContext save:&error];
        if (error != nil) {
            NSLog(@"Delete Product Failed: %@", error);
        }
        else {
            NSLog(@"Product Delete.");
        }
    }
}




- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Core_Data.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataSample_C" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

@end
