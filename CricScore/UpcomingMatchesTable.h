//
//  UpcomingMatchesTable.h
//  CricScore
//
//  Created by Shubham Sharma on 29/06/17.
//  Copyright © 2017 Shubham Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpcomingMatchesTable : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *upcomingTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading4;

-(void)makeConnection;

@end
