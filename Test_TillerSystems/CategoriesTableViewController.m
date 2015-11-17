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
#import <SVProgressHUD.h>
#import "Helpers.h"



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
    
    [self setRefreshControl:[[UIRefreshControl alloc] init]];
    [[self refreshControl] addTarget:self
                              action:@selector(refreshData)
                    forControlEvents:UIControlEventValueChanged];
    
    dataManager = [DataManager sharedInstance];
    [self refreshData];
}



- (void)refreshData
{
    CategoriesTableViewController __weak *weakSelf = self;
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading_In_Progress", nil)];
    [DataManager loadDataWithCompletionBlock:
     ^{
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            [[weakSelf tableView] reloadData];
                            [SVProgressHUD dismiss];
                            if ([[weakSelf refreshControl] isRefreshing])
                            {
                                [[weakSelf refreshControl] endRefreshing];
                            }
                        });
     }];
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
    if ([[currentCategorie color] isEqual:[NSNull null]] == NO)
    {
        CGSize size = CGSizeMake(40, 40);
        [[cell imageView] setImage:[UIImage imageFromColor:[UIColor colorWithHexString:[currentCategorie color]] size:size]];
    }
    [[cell textLabel] setText:[currentCategorie name]];
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%ld %@", (unsigned long)[[currentCategorie products] count], NSLocalizedString(@"products", nil)]];
    
    // If current categorie have 0 product the cell configuration is different to represent it.
    if ([[currentCategorie products] count] == 0)
    {
        [[cell contentView] setAlpha:0.5];
        [[cell imageView] setAlpha:0.2];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    else
    {
        [[cell contentView] setAlpha:1.0];
        [[cell imageView] setAlpha:1.0];
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
