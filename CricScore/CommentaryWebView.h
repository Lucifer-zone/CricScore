//
//  CommentaryWebView.h
//  CricScore
//
//  Created by Shubham Sharma on 10/07/17.
//  Copyright © 2017 Shubham Sharma. All rights reserved.
//

#import "ViewController.h"

@interface CommentaryWebView : ViewController

@property (strong, nonatomic) IBOutlet UIWebView *CommentaryView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading1;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading2;
@property (weak, nonatomic) IBOutlet UILabel *score11;
@property (weak, nonatomic) IBOutlet UILabel *score21;
@property (weak, nonatomic) IBOutlet UILabel *score12;
@property (weak, nonatomic) IBOutlet UILabel *score22;
@property (weak, nonatomic) IBOutlet UILabel *oversfield1;
@property (weak, nonatomic) IBOutlet UILabel *extrainfo;
@property (weak, nonatomic) IBOutlet UIImageView *team1Image;
@property (weak, nonatomic) IBOutlet UIImageView *team2Image;
@property NSString *matchid;
@property (weak, nonatomic) IBOutlet UILabel *oversfield2;
@property (weak, nonatomic) IBOutlet UILabel *Runratefield1;
@property (weak, nonatomic) IBOutlet UILabel *Runratefield2;

@end
