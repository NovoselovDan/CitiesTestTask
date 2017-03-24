//
//  CitiesViewController.m
//  CitiesTestTask
//
//  Created by Daniil Novoselov on 19.03.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

#import "CitiesViewController.h"
#import "UserSession.h"

@interface CitiesViewController () <UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (assign, nonatomic) BOOL isAuthenticated;
@property (assign, nonatomic) BOOL isDataLoading;
@property (assign, nonatomic) BOOL didLoadFullList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refresh;
@property (strong, nonatomic) UIActivityIndicatorView *loadingActivity;
@property (strong, nonatomic) UIView *footerView;

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSArray *filteredCities;


@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;


@end

@implementation CitiesViewController


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        _filteredCities = [NSArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isAuthenticated = [UserSession currentSession].isAuthorized;
    _isDataLoading = NO;
    
    [self setUpMainAppereance];
    [self initFooterView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_searchController.active && ![_searchController.searchBar.text isEqualToString:@""]) {
        return _filteredCities.count;
    }
    NSInteger rows = [_cityStore allCites].count;
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityUITableViewCell" forIndexPath:indexPath];

    City *currentCity;
    if (_searchController.active && ![_searchController.searchBar.text isEqualToString:@""]) {
        currentCity = _filteredCities[indexPath.row];
    } else {
        currentCity = [_cityStore allCites][indexPath.row];
    }
    
    cell.textLabel.text = currentCity.title;
    if (currentCity.region) {
        cell.detailTextLabel.text = currentCity.region;
    } else {
        cell.detailTextLabel.text = nil;
    }
    
    return cell;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    
    if (editing)
    {
        self.editButtonItem.title = NSLocalizedString(@"Готово", @"Done");
    }
    else
    {
        self.editButtonItem.title = NSLocalizedString(@"Изменить", @"Edit");
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        City *city = [_cityStore allCites][indexPath.row];
        [_cityStore removeCity:city];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!_didLoadFullList && !_isDataLoading && !_searchController.active && [_searchController.searchBar.text isEqualToString:@""])
    {
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[_tableView.tableFooterView viewWithTag:10];
        if (![indicator isAnimating]) {
            [indicator startAnimating];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    BOOL endOfTable = (scrollView.contentOffset.y >= (([_cityStore allCites].count * _tableView.estimatedRowHeight) - scrollView.frame.size.height));
    
    if (!_didLoadFullList && endOfTable && !_isDataLoading && [_cityStore allCites].count > 0 && !scrollView.dragging && !scrollView.decelerating && !_searchController.active && [_searchController.searchBar.text isEqualToString:@""])
    {
        [(UIActivityIndicatorView *)[_tableView.tableFooterView viewWithTag:10] startAnimating];
        [self loadNextCities];
    }
}

#pragma mark - UI Search Control methods

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if ([searchController.searchBar.text isEqualToString:@""]) {
        [self resumeFetching];
        [_tableView reloadData];
    } else {
        [self stopFething];
        [self filterContentForSearchText:searchController.searchBar.text];
    }
}

- (void)filterContentForSearchText:(NSString *)searchText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title CONTAINS[cd] %@", searchText];
    _filteredCities = [[_cityStore allCites] filteredArrayUsingPredicate:predicate];
    
    [_tableView reloadData];
}

#pragma mark - IBActions

- (IBAction)addCity:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"addCityVC" sender:self];
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"dismissAuthVC"]) {
        _isAuthenticated = [UserSession currentSession].isAuthorized;
        [self updateView];
    } else if ([segue.identifier isEqualToString:@"dismissAddCityVC"]) {
        //UIViewController *vc = segue.sourceViewController;
        /*
         City *newCity;// = [_cityStore createNewCity];
         NSUInteger index = [[_cityStore allCites] indexOfObject:newCity];
         [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
         withRowAnimation:UITableViewRowAnimationAutomatic];
         */
    }
}

- (IBAction)loginButtonAction:(id)sender {
    if (_isAuthenticated) {
        _isAuthenticated = NO;
        [self updateView];
    } else {
        [self performSegueWithIdentifier:@"authVC" sender:self];
        
    }
}

#pragma mark - Custom Methods

- (void)setUpMainAppereance {
    UIBarButtonItem *editBBItem = self.editButtonItem;
    editBBItem.title = NSLocalizedString(@"Изменить", @"Edit");
    self.navigationItem.leftBarButtonItem = editBBItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(addCity:)];
    UIBarButtonItem *loginButton = [_toolbar.items firstObject];
    loginButton.title = _isAuthenticated?@"Выйти":@"Авторизоваться";
    
    _refresh = [UIRefreshControl new];
    _refresh.tintColor = [UIColor blackColor];
    [_refresh addTarget:self action:@selector(loadCities) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refresh];
    
    _tableView.estimatedRowHeight = 44;
    
    //UI Search Control
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.delegate = self;
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.delegate = self;
    _searchController.hidesNavigationBarDuringPresentation = YES;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.definesPresentationContext = YES;
    _tableView.tableHeaderView = _searchController.searchBar;
    
    self.definesPresentationContext = YES;

}

- (void)updateView {
    UIBarButtonItem *loginButton = [_toolbar.items firstObject];
    
    if (_isAuthenticated) {
        loginButton.title = @"Выйти";
        
        [self.tableView reloadData];
    } else {
        loginButton.title = @"Авторизоваться";
    }
}

- (void)initFooterView {
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    _footerView.backgroundColor = [UIColor clearColor];
    
    _loadingActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loadingActivity.tag = 10;
    _loadingActivity.frame = CGRectMake(0, 0, 20, 20);
    _loadingActivity.center = _footerView.center;
    //_loadingActivity.hidesWhenStopped = YES;
    [_footerView addSubview:_loadingActivity];
    
    //[_loadingActivity startAnimating];
}

- (void)loadCities {
    _isDataLoading = YES;
    [_cityStore fetchCitiesFirst:YES completion:^(NSArray *fetchedCities, BOOL didLoadFullList, NSError *error) {
        [_refresh endRefreshing];
        _isDataLoading = NO;
        if (!error) {
            _didLoadFullList = didLoadFullList;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!_didLoadFullList) {
                    _tableView.tableFooterView = _footerView;
                    [(UIActivityIndicatorView *)[_footerView viewWithTag:10] startAnimating];
                }
                [_tableView reloadData];
            });
        } else {
            NSLog(@"loadCities error: %@", error.localizedDescription);
        }
    }];
}

- (void)loadNextCities {
    _isDataLoading =YES;
    [_cityStore fetchCitiesFirst:NO completion:^(NSArray *fetchedCities, BOOL didLoadFullList, NSError *error) {
        _isDataLoading = NO;
        
        if (!error) {
            _didLoadFullList = didLoadFullList;
            
            NSInteger lastIndex = [[_cityStore allCites] indexOfObject:[fetchedCities firstObject]];
            NSMutableArray *indexPaths = [NSMutableArray new];
            for (int i=0; i < fetchedCities.count; i++) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:(lastIndex + i) inSection:0]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (didLoadFullList) {
                    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
                }
                [(UIActivityIndicatorView *)[_tableView.tableFooterView viewWithTag:10] stopAnimating];
                [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
            });
            
            //[_tableView reloadData];
        } else {
            NSLog(@"loadCities error: %@", error.localizedDescription);
        }
        
    }];
}

- (void)stopFething {
    _isDataLoading = NO;
    [(UIActivityIndicatorView *)[_tableView.tableFooterView viewWithTag:10] stopAnimating];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)resumeFetching {
    if (!_didLoadFullList) {
        _tableView.tableFooterView = _footerView;
        [(UIActivityIndicatorView *)[_tableView.tableFooterView viewWithTag:10] startAnimating];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
