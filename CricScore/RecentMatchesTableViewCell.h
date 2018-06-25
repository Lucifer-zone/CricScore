//
//  RecentMatchesTableViewCell.h
//  CricScore
//
//  Created by Shubham Sharma on 27/06/17.
//  Copyright © 2017 Shubham Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentMatchesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *matchType;
@property (weak, nonatomic) IBOutlet UIImageView *teamOneLogo;
@property (weak, nonatomic) IBOutlet UIImageView *teamTwoLogo;
@property (weak, nonatomic) IBOutlet UILabel *teamOneFirstInn;
@property (weak, nonatomic) IBOutlet UILabel *teamOneSecondInn;
@property (weak, nonatomic) IBOutlet UILabel *teamTwoFirstInn;
@property (weak, nonatomic) IBOutlet UILabel *teamTwoSecondInn;
@property (weak, nonatomic) IBOutlet UILabel *teamOne;
@property (weak, nonatomic) IBOutlet UILabel *teamTwo;
@property (weak, nonatomic) IBOutlet UILabel *Runrate1;
@property (weak, nonatomic) IBOutlet UILabel *Runrate2;
@property (weak, nonatomic) IBOutlet UILabel *ov1;
@property (weak, nonatomic) IBOutlet UILabel *ov2;

@end
