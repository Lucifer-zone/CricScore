//
//  RecentMatchesTable.h
//  CricScore
//
//  Created by Shubham Sharma on 29/06/17.
//  Copyright © 2017 Shubham Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentMatchesTable : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *recentTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading3;



@end
