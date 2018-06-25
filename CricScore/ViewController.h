//
//  ViewController.h
//  CricScore
//
//  Created by Shubham Sharma on 27/06/17.
//  Copyright © 2017 Shubham Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UINavigationItem *nav;
@property (weak, nonatomic) IBOutlet UILabel *newsLabel;
@property (weak, nonatomic) IBOutlet UILabel *LiveLabel;
@property (weak, nonatomic)  IBOutlet UILabel *matchTitle;
@property (weak, nonatomic)  IBOutlet UILabel *firstTeamScore;
@property (weak, nonatomic) IBOutlet UILabel *secondTeamScore;
@property (weak, nonatomic) IBOutlet UILabel *firstTeam;
@property (weak, nonatomic) IBOutlet UILabel *secondTeam;
@property (weak, nonatomic) IBOutlet UIImageView *firstTeamLogo;
@property (weak, nonatomic) IBOutlet UIImageView *secondTeamLogo;
@property (weak, nonatomic) IBOutlet UILabel *extraInfo;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading3;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading4;
@property (weak, nonatomic) IBOutlet UILabel *RunRate1;
@property (weak, nonatomic) IBOutlet UILabel *RunRate2;
@property (weak, nonatomic) IBOutlet UILabel *Overs1;
@property (weak, nonatomic) IBOutlet UILabel *Overs2;
@property (weak, nonatomic) IBOutlet UICollectionView *newscollectionview;



- (IBAction)more:(id)sender;

@end

