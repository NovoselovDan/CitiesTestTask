//
//  AddCityViewController.m
//  CitiesTestTask
//
//  Created by Daniil Novoselov on 24.03.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

#import "AddCityViewController.h"

@interface AddCityViewController ()

@property (strong, nonatomic) UISearchController *searchController;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AddCityViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpMainAppereance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

- (void)setUpMainAppereance {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Готово"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(donePressed:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Отмена"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(cancelPressed:)];
    
    
}

#pragma mark - UI Search Results Updating delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}


#pragma mark - IBActions

- (IBAction)donePressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"dismissAddCityVC" sender:self];
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
