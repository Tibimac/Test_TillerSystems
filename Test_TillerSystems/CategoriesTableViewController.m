//
//  CategoriesTableViewController.m
//  Test_TillerSystems
//
//  Created by Thibault Le Cornec on 15/11/15.
//  Copyright © 2015 TillerSystems. All rights reserved.
//

#import "CategoriesTableViewController.h"
#import "ProductsTableViewController.h"
#import "DataManager.h"
#import "Categorie.h"



#define NB_SECTION 1
static NSString *kCellIdentifier = @"categorieCell";



@interface CategoriesTableViewController ()
{
    DataManager *dataManager;
    ProductsTableViewController *productsTableViewController;
}
@end



@implementation CategoriesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"Categories_Title", nil)];
    [[self tableView] setDataSource:self];
    [[self tableView] setDelegate:self];
    
    dataManager = [DataManager sharedInstance];
    
    CategoriesTableViewController __weak *weakSelf = self;
    [DataManager loadDataWithCompletionBlock:
     ^{
        dispatch_async(dispatch_get_main_queue(),
        ^{
             [weakSelf reloadData];
        });
     }];
}

     
- (void)reloadData
{
    [[self tableView] reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NB_SECTION;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dataManager categories] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier];
    }
    
    Categorie *currentCategorie = [[dataManager categories] objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[currentCategorie name]];
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%ld %@", (unsigned long)[[currentCategorie products] count], NSLocalizedString(@"products", nil)]];
    
    // If current categorie have 0 product the cell configuration is different to represent it.
    if ([[currentCategorie products] count] == 0)
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    else
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (productsTableViewController == nil)
    {
        productsTableViewController = [[ProductsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    
    // Push products table view only if the categorie has products.
    if ([[[[dataManager categories] objectAtIndex:indexPath.row] products] count] > 0)
    {
        [productsTableViewController setCurrentCategorieIndexPath:indexPath];
        [[self navigationController] pushViewController:productsTableViewController animated:YES];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
