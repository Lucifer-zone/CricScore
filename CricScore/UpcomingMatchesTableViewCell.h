//
//  UpcomingMatchesTableViewCell.h
//  CricScore
//
//  Created by Shubham Sharma on 27/06/17.
//  Copyright © 2017 Shubham Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpcomingMatchesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateField;
@property (weak, nonatomic) IBOutlet UILabel *team1;
@property (weak, nonatomic) IBOutlet UILabel *team2;
@property (weak, nonatomic) IBOutlet UILabel *matchInfo;
@property (weak, nonatomic) IBOutlet UILabel *monthfield;

@property (weak, nonatomic) IBOutlet UIImageView *team2Logo;
@property (weak, nonatomic) IBOutlet UIImageView *team1Logo;
@end
