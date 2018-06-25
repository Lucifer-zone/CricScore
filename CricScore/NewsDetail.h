//
//  NewsDetail.h
//  CricScore
//
//  Created by Shubham Sharma on 30/06/17.
//  Copyright © 2017 Shubham Sharma. All rights reserved.
//

#import "ViewController.h"

@interface NewsDetail : ViewController
@property NSString *url;
@property (strong, nonatomic) IBOutlet UIWebView *webfield;

@end
