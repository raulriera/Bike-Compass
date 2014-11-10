//
//  NetworksTableViewController.m
//  BikeCompass
//
//  Created by Raúl Riera on 16/09/2014.
//  Copyright (c) 2014 Raúl Riera. All rights reserved.
//

#import "NetworksTableViewController.h"
#import "NetworkTableViewCell.h"
#import "NetworksRepository.h"
#import "UIAlertController+Extended.h"

@interface NetworksTableViewController () <UISearchResultsUpdating>

@property (strong, nonatomic) NSArray *networks;
@property (strong, nonatomic) NSArray *filteredNetworks;
@property (nonatomic, strong) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation NetworksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self allNetworks];
    
    // Create the search controller, but we'll make sure that this controller
    // performs the results updating.
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    // Make sure the that the search bar is visible within the navigation bar.
    [self.searchController.searchBar sizeToFit];
    
    // Include the search controller's search bar within the table's header view.
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
    // If this is not the first time this screen is appearning,
    // don't show anything to close it
    if (![NetworksRepository sharedRepository].currentNetwork) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)allNetworks
{
    [[NetworksRepository sharedRepository] networksWithBlock:^(NSArray *networks, NSError *error) {
        
        if (!error) {
            self.networks = networks;
            self.filteredNetworks = self.networks;
            [self.tableView reloadData];
        } else {
            UIAlertController * alert = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"Network", @"Generic network error message title")
                                          message:NSLocalizedString(@"It appears you are experiencing network problems", @"Generic network error message")
                                          acceptanceBlock:^(UIAlertAction *action) {
                                              [self allNetworks];
                                          }];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [searchController.searchBar text];
    
    if (!searchString || searchString.length <= 0) {
        self.filteredNetworks = self.networks;
    }
    else {
        self.filteredNetworks = [[NetworksRepository sharedRepository] filterNetworks:self.networks usingKeyword:searchString];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filteredNetworks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NetworkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"networkCellIdentifier" forIndexPath:indexPath];
    
    Network *network = [self.filteredNetworks objectAtIndex:indexPath.row];
        
    cell.networkTitle.text = [NSString stringWithFormat:@"%@, %@", network.location.city, network.location.country];
    cell.networkSubtitle.text = network.name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate) {
        [self.delegate viewController:self didChooseNetwork:[self.filteredNetworks objectAtIndex:indexPath.row]];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismiss:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
