//
//  ProductsTableViewController.m
//  Test_TillerSystems
//
//  Created by Thibault Le Cornec on 15/11/15.
//  Copyright © 2015 TillerSystems. All rights reserved.
//

#import "ProductsTableViewController.h"
#import "DataManager.h"
#import "Categorie.h"
#import "Product.h"



#define NB_SECTION 1
static NSString *kCellIdentifier = @"productCell";



@interface ProductsTableViewController ()
{
    DataManager *dataManager;
    NSArray *currentProducts;
}
@end



@implementation ProductsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"Products_Title", nil)];
    dataManager = [DataManager sharedInstance];
}



- (void)viewWillAppear:(BOOL)animated
{
    currentProducts = [[[dataManager categories] objectAtIndex:_currentCategorieIndexPath.row] products];
    [[self tableView] reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NB_SECTION;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [currentProducts count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    Product *currentProduct = [currentProducts objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[currentProduct name]];
    
    // Configuration of the price in the current locale for currency (inherit from current region) of the device
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *priceString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:([[currentProduct price] integerValue]/100)]];
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%@", priceString]];
    
    return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end