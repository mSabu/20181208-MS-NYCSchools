//
//  NYSchoolListViewController.m
//  20181208-MS-NYCSchools
//
//  Created by Manjusha Satheesh Sabu on 12/7/18.
//  Copyright © 2018 msabu. All rights reserved.
//

#import "NYSchoolListViewController.h"
#import "NYSchoolDetailViewController.h"
#import "SchoolInfoNetworkLayer.h"

@interface NYSchoolListViewController () <UISearchBarDelegate>

{
    BOOL isFiltered ;
    NSArray * filteredList ;
}

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation NYSchoolListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    [self retrieveData];
    isFiltered = NO;
}

- (void)configureView {
    self.title = @"NYC Schools - 2018";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ListCellIdentifier"];
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension ;
}

-(void)retrieveData {
    [[SchoolInfoNetworkLayer sharedInstance] downloadSchoolListWithCompletionHandler:^(NSArray * _Nonnull response, NSError * _Nonnull error) {
        if (error) {
            [self showAlert: error.localizedDescription];
        }
        else {
            if (response) {
                self.schoolListArray = response ;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }
    }];
}

-(void) showAlert : (NSString *)message {
    UIAlertController *errAlert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
    [errAlert addAction:dismiss];
    [self presentViewController:errAlert animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (isFiltered ? filteredList.count : self.schoolListArray.count);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCellIdentifier" forIndexPath:indexPath];
    
    SchoolInfo * schoolInfo = isFiltered ? [filteredList objectAtIndex:indexPath.row] :[self.schoolListArray objectAtIndex:indexPath.row] ;
    
    cell.textLabel.text = [schoolInfo.schoolName uppercaseString];
    cell.textLabel.numberOfLines = 3;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kShowDetailId sender:indexPath];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = sender ;
    
    SchoolInfo * info = isFiltered ? [filteredList objectAtIndex:indexPath.row] : [self.schoolListArray objectAtIndex:indexPath.row] ;
    NYSchoolDetailViewController * details = ((UINavigationController *)segue.destinationViewController).viewControllers[0];
    details.schoolInfo = info ;

}

#pragma mark - Search Bar Delegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    filteredList = [NSMutableArray array] ;
    if (searchText.length) {
        isFiltered = YES ;
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"SELF.schoolName contains[cd] %@",
                                        searchText];

        filteredList = [self.schoolListArray filteredArrayUsingPredicate:resultPredicate];
        [self.tableView reloadData];
    }
    else {
        isFiltered = NO;
        [self.tableView reloadData];
    }
}


@end
