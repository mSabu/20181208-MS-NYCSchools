//
//  SchoolDetailTableViewController.m
//  NetworkLayer
//
//  Created by Manjusha Satheesh Sabu on 12/7/18.
//  Copyright © 2018 msabu. All rights reserved.
//

#import "NYSchoolDetailViewController.h"
#import "SchoolInfoNetworkLayer.h"

@interface NYSchoolDetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel *mathScore;
@property (strong, nonatomic) IBOutlet UILabel *readingScore;
@property (strong, nonatomic) IBOutlet UILabel *writingScore;

@end

@implementation NYSchoolDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    [self getSchoolSATScores];
}
-(void)configureView {
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeDetailsView)];
   
    //inorder to see the title without ellipsis
    UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 50)];
    tlabel.text = self.schoolInfo.schoolName;
    tlabel.font = [UIFont fontWithName:@"Helvetica-Bold" size: 25.0];
    tlabel.backgroundColor =[UIColor clearColor];
    tlabel.numberOfLines = 2;
    tlabel.adjustsFontSizeToFitWidth=YES;
    tlabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=tlabel;
}


-(void)getSchoolSATScores {
    [[SchoolInfoNetworkLayer sharedInstance] downloadSchoolDetails:self.schoolInfo.dbnId withCompletionHandler:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        self.schoolInfo.satStatisticsInfo = response ;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateSATScores];
        });
        if (!response || error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tableView.tableHeaderView = nil;
                [self.tableView reloadData];
            });
        }
    }];
}

-(void) updateSATScores{
    self.mathScore.text = self.schoolInfo.satStatisticsInfo[@"MathScore"];
    self.writingScore.text = self.schoolInfo.satStatisticsInfo[@"WritingScore"];
    self.readingScore.text = self.schoolInfo.satStatisticsInfo[@"ReadingScore"];
}

-(void)closeDetailsView {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.schoolInfo.schoolInfoDetails.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id item = ((NSDictionary*)[self.schoolInfo.schoolInfoDetails objectAtIndex:section])[kSectionItem];
    
    if ([item isKindOfClass:[NSArray class]]) return ((NSArray*)item).count;
    else if ([item isKindOfClass:[NSDictionary class]]) return ((NSDictionary*)item).count;
    else return 1;
    
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return ((NSDictionary*)[self.schoolInfo.schoolInfoDetails objectAtIndex:section])[kSectionTitle];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCellIdentifier"];
    if (cell == nil) { cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailCellIdentifier"];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.textLabel.numberOfLines = 20;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];

    NSDictionary * schoolDetails = [self.schoolInfo.schoolInfoDetails objectAtIndex:indexPath.section] ;
    id item = schoolDetails[kSectionItem];
    if ([item isKindOfClass:[NSArray class]]) {
        cell.textLabel.text = [((NSArray*)item) objectAtIndex:indexPath.row];
    }
    else if ([item isKindOfClass:[NSDictionary class]]) {
        NSDictionary * cellItem = item;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ : ",cellItem.allKeys[indexPath.row]]
                                                                                 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor grayColor] }]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:cellItem.allValues[indexPath.row]
                                                                                 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor blackColor]
                                                                                              }]];
        cell.textLabel.attributedText = attributedString;
    }
    else {
        cell.textLabel.text = schoolDetails[kSectionItem];
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end

