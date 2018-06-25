//
//  ViewController.m
//  CricScore
//
//  Created by Shubham Sharma on 27/06/17.
//  Copyright © 2017 Shubham Sharma. All rights reserved.
//

#import "ViewController.h"
#import  "NewsCell.h"
#import "NewsDetail.h"
@interface ViewController ()
{
    NSString *getTeam2;
    NSString *getMatchId;
    NSString *getTeam1;
    NSString *getTeam2Score;
    NSString *getMatchType;
   
    NSString *getTeam1Score;
    NSMutableArray *newsdata;
    NSString *wickets1;
    NSString *wickets2;
    UIRefreshControl *refreshControl;
    NSString *runrate1;
    NSString *runrate2;
    NSString *over1;
    NSString *over2;
}

-(void)getMatchidfun;
-(void)putData;
-(void)getNews;

@end

@implementation ViewController

NSString *Api_key = @"?apikey=dedcqTtSxWfBfaG2OgfXU6b3zEU2";
NSString *Api_keynews = @"&apikey=873db5af2ce545dea199a8aa30426681";



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically
     [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:@"Home"];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:@" "];
[[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:@" "];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
    //Load NIB

    self.newscollectionview.delegate = self;
    self.newscollectionview.dataSource = self;
    self.newscollectionview.backgroundColor = [UIColor colorWithRed:0.09 green:0.09 blue:0.09 alpha:1.0];
   
    
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    
    
    getMatchId = [NSString new];
    getTeam1 = [NSString new];
    getTeam2 = [NSString new];
    wickets1 = [NSString new];
    wickets2 = [NSString new];
    over1 = [NSString new];
    over2 = [NSString new];
    runrate1 = [NSString new];
    runrate2 = [NSString new];
    
    _firstTeamScore.font = [UIFont fontWithName:@"Montserrat-Bold" size:31];
    _secondTeamScore.font = [UIFont fontWithName:@"Montserrat-Bold" size:31];
    _Overs1.font = [UIFont fontWithName:@"Montserrat-Regular" size:11];
    _Overs2.font = [UIFont fontWithName:@"Montserrat-Regular" size:11];
    _RunRate1.font = [UIFont fontWithName:@"Montserrat-Regular" size:11];
    _RunRate2.font = [UIFont fontWithName:@"Montserrat-Regular" size:11];
    _newsLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:17];
    _LiveLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:15];

    for (NSString* family in [UIFont familyNames]) {
        NSLog(@"--family of font%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family]) {
            NSLog(@"--name of font%@", name);
        }
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlstring = @"http://cricapi.com/api/matches";
    NSString *addkey = [NSString stringWithFormat:@"%@%@",urlstring,Api_key];
    
    NSURL *url = [NSURL URLWithString:addkey];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSMutableArray *newMatches = [NSMutableArray new];
        newMatches = [json objectForKey:@"matches"];
        bool find = false;
        NSString *team1name = [NSString new];
        
        for(int i=0;i<newMatches.count && find!=true;i++)
        {
            team1name = [newMatches[i] valueForKey:@"team-1"];
            if([[newMatches[i] valueForKey:@"matchStarted"] isEqual:@true] && [UIImage imageNamed:team1name]!=NULL){
                getMatchId = [newMatches[i] valueForKey:@"unique_id"];
                
                find = true;
            }
        }
        if(find == false){
            getMatchId=[newMatches[1] valueForKey:@"unique_id"];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
         //  [self getMatchidfun];
            [self getNews];
            
        });
    }];
    
    [dataTask resume];
}





-(void)getMatchidfun{
    [_loading3 startAnimating];
    //Use MatchId
    NSURLSession *session2 =[NSURLSession sharedSession];
    NSString *urlstring2 = @"http://cricapi.com/api/fantasySummary";
    NSString *useMatchid = [NSString stringWithFormat:@"&unique_id=%@",getMatchId];
    NSString *addkey2 = [NSString stringWithFormat:@"%@%@%@",urlstring2,Api_key,useMatchid];
    
    NSURL *url2 = [NSURL URLWithString:addkey2];
    wickets2 = @"";
    wickets1 = @"";
    NSLog(@"%@",url2);
    NSURLSessionDataTask *dataTask2=[session2 dataTaskWithURL:url2 completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        NSDictionary *json2=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"---JSON2--%@----",json2);
        
        NSMutableArray *sumdata = [NSMutableArray new];
        sumdata = [ json2 objectForKey:@"data"];
        
        // NSMutableArray *sumteams=[NSMutableArray new];
        // sumteams=[ sumdata valueForKey:@"team"];
        
        NSMutableArray *sumbatting=[NSMutableArray new];
        sumbatting=[ sumdata valueForKey:@"batting"];
        if(sumbatting.count!=0){
            
            NSMutableArray *teamdata = [NSMutableArray new];
            teamdata = [sumbatting valueForKey:@"title"];
            NSLog(@"---Teamdata--%@",teamdata);
            NSString *team1data  =[[[teamdata[0] stringByReplacingOccurrencesOfString:@" 1st" withString:@""]stringByReplacingOccurrencesOfString:@" 2nd" withString:@""]stringByReplacingOccurrencesOfString:@" innings" withString:@""];
            NSLog(@"dfdjf %@",team1data);
            getTeam1=[team1data stringByReplacingOccurrencesOfString:@" team" withString:@""];
            
            NSString *team2data=[[[teamdata[1] stringByReplacingOccurrencesOfString:@" 1st" withString:@""]stringByReplacingOccurrencesOfString:@" 2nd" withString:@""]stringByReplacingOccurrencesOfString:@" innings" withString:@""];
            getTeam2=[team2data stringByReplacingOccurrencesOfString:@" team" withString:@""];
            
            
            NSMutableArray *sumScore=[NSMutableArray new];
            sumScore=[ sumbatting[0] valueForKey:@"scores"];
            if(sumScore!=NULL){
                bool found=false;
                
                NSMutableArray *array = [NSMutableArray new];
                NSString *overshelp=[NSString new];
                for(int i=0;i<sumScore.count;i++)
                {
                    if([[sumScore[i] valueForKey:@"batsman"] isEqual:@"Total"])
                    {
                        found=true;
                        
                        getTeam1Score=[sumScore[i] valueForKey:@"R"];
                        NSLog(@"Runs----%@",getTeam1Score);
                        NSString *runR=[sumScore[i] valueForKey:@"M"];
                        runrate1=[NSString stringWithFormat:@"R.R: %@",[runR substringWithRange:NSMakeRange(1, 4)]];
                        NSString *str = [sumScore[i] valueForKey:@"dismissal-info"];
                        for (int i = 0; i < [str length]; i++) {
                            NSString *ch = [str substringWithRange:NSMakeRange(i, 1)];
                            if([ch isEqual:@";"]){
                                overshelp=[str substringWithRange:NSMakeRange(i+2, 3)];
                                over1=[NSString stringWithFormat:@"Overs:%@",overshelp];
                            }
                            [array addObject:ch];
                        }
                        NSLog(@"Runrate----%@",runrate1);
                        NSLog(@"---overs %@",over1);
                    }
                    
                }
                
                if(![array[1] isEqual:@"a"]){
                    wickets1=[NSString stringWithFormat:@"/%@",array[1]];
                }
                
                
                //for second team
                
                NSMutableArray *sumScore2=[NSMutableArray new];
                sumScore2=[ sumbatting[1] valueForKey:@"scores"];
                NSLog(@"%@",sumScore2);
                if(sumScore2!=NULL ){
                    
                    bool found2=false;
                    NSMutableArray *array2 = [NSMutableArray new];
                    NSString *overshelp=[NSString new];
                    for(int i=0;i<sumScore2.count;i++)
                    {
                        if([[sumScore2[i] valueForKey:@"batsman"] isEqual:@"Total"])
                        {
                            found2=true;
                            
                            getTeam2Score=[sumScore2[i] valueForKey:@"R"];
                            NSLog(@"Second Runs----%@",getTeam2Score);
                            NSString *runR=[sumScore2[i] valueForKey:@"M"];
                            runrate2=[NSString stringWithFormat:@"R.R: %@",[runR substringWithRange:NSMakeRange(1, 4)]];
                            
                            NSString *str2 = [sumScore2[i] valueForKey:@"dismissal-info"];
                            for (int i = 0; i < [str2 length]; i++) {
                                NSString *ch2 = [str2 substringWithRange:NSMakeRange(i, 1)];
                                
                                if([ch2 isEqual:@";"]){
                                    overshelp=[str2 substringWithRange:NSMakeRange(i+2, 3)];
                                    over2=[NSString stringWithFormat:@"Overs:%@",overshelp];
                                }
                                [array2 addObject:ch2];
                            }
                            NSLog(@"Second Wickets----%@",array2[1]);
                        
                        }
                    }
                    NSLog(@"Runrate2----%@",runrate1);
                    NSLog(@"---overs2 %@",over1);

                    if(![array2[1] isEqual:@"a"]){
                        wickets2=[NSString stringWithFormat:@"/%@",array2[1]];
                    }
                }
                
                else{
                    
                    getTeam2Score=@"  ";
                }
                
            }else{
                getTeam1Score=@"  ";
                getTeam2Score=@"  ";
            }
        }else{
            getTeam1Score=@"  ";
            getTeam2Score=@"  ";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self putData];
        });
    }];
    
    [dataTask2 resume];
}

-(void)putData{
    
    NSLog(@"Going Further");
    if(getMatchId!=NULL){
        NSURLSession *session2 =[NSURLSession sharedSession];
        NSString *urlstring2=@"http://cricapi.com/api/cricketScore";
        NSString *useMatchid=[NSString stringWithFormat:@"&unique_id=%@",getMatchId];
        NSString *addkey2=[NSString stringWithFormat:@"%@%@%@",urlstring2,Api_key,useMatchid];
        
        NSURL *url2 = [NSURL URLWithString:addkey2];
        
        NSLog(@"%@",url2);
        NSURLSessionDataTask *dataTask2=[session2 dataTaskWithURL:url2 completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
            NSDictionary *json4=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *extradata=[json4 objectForKey:@"innings-requirement"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_loading3 stopAnimating];
                _secondTeamScore.text=[NSString stringWithFormat:@"%@%@",getTeam2Score,wickets2];
                _extraInfo.text=extradata;
                _matchTitle.text=[json4 objectForKey:@"type"];
                _firstTeamScore.text=[NSString stringWithFormat:@"%@%@",getTeam1Score,wickets1];
                _firstTeam.text=getTeam1;
                _secondTeam.text=getTeam2;
                _firstTeamLogo.image=[UIImage imageNamed:_firstTeam.text];
                _secondTeamLogo.image=[UIImage imageNamed:_secondTeam.text];
                _Overs1.text=over1;
                _Overs2.text=over2;
                _RunRate1.text=runrate1;
                _RunRate2.text=runrate2;
            });
            
        }];
        
        [dataTask2 resume];
        
        
    }
}
-(void)getNews{
    [_loading4 startAnimating];
    NSURLSession *newssession =[NSURLSession sharedSession];
    NSString *urlstring3=@"https://newsapi.org/v1/articles?source=espn-cric-info&sortBy=latest";
    
    NSString *addkey3=[NSString stringWithFormat:@"%@%@",urlstring3,Api_keynews];
    
    NSURL *url3 = [NSURL URLWithString:addkey3];
    
    NSLog(@"%@",url3);
    NSURLSessionDataTask *dataTask3=[newssession dataTaskWithURL:url3 completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        NSDictionary *json3=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        newsdata=[json3 objectForKey:@"articles"];
        NSLog(@"-----%@",newsdata[0]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_loading4 stopAnimating];
            [_newscollectionview reloadData];
            
        });
    }];
    [dataTask3 resume];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return newsdata.count;
}


// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView
                                  dequeueReusableCellWithReuseIdentifier:@"NewsCell"
                                  forIndexPath:indexPath];
    
    NSLog(@"cell---%@",cell);
    
    NSString *imagestr=[[newsdata objectAtIndex:indexPath.row] valueForKey:@"urlToImage"];
    NSURL *url = [NSURL URLWithString:imagestr];
    NSData *image = [[NSData alloc] initWithContentsOfURL:url];


    UIImageView *newsimage=(UIImageView *)[cell viewWithTag:100];
    newsimage.frame=CGRectMake(10,10,143,128);
    newsimage.image=[UIImage imageWithData:image];
    newsimage.alpha=0.9;
    // Get the Layer of any view
    CALayer * l = [newsimage layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];

    UILabel *label=(UILabel*)[cell viewWithTag:101];
    label.font=[UIFont fontWithName:@"Montserrat-Regular" size:12];
    label.frame=CGRectMake(10, 137, 143, 65);
    label.text=[[newsdata objectAtIndex:indexPath.row ]valueForKey:@"title"];
   // label.textColor=[UIColor colorWithRed:0.80 green:0.85 blue:0.90 alpha:1.0];
    
   // label.font=[UIFont fontWithName:@"KohinoorBangla-Light" size:14.0f];
    label.numberOfLines=3;
    label.textAlignment=NSTextAlignmentLeft;
    NSLog(@"lab---%@",label);
    [cell addSubview:label];
    [cell addSubview:newsimage];
    cell.backgroundColor=[UIColor colorWithRed:0.16 green:0.16 blue:0.16 alpha:1.0];
    cell.layer.borderWidth = 1.0;
    cell.layer.borderColor =  [UIColor colorWithRed:0.16 green:0.16 blue:0.16 alpha:1.0].CGColor;
    
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    cell.clipsToBounds = YES;
/*for (UIView *v in [cell.contentView subviews])
    {
        [v removeFromSuperview];
       
    }*/
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *urlString=[[newsdata objectAtIndex:indexPath.row]valueForKey:@"url"];
    UICollectionViewCell *cell = [collectionView
                                  dequeueReusableCellWithReuseIdentifier:@"NewsCell"
                                  forIndexPath:indexPath];
    cell.layer.borderColor =  [UIColor whiteColor].CGColor;
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewsDetail * controller = [storyboard instantiateViewControllerWithIdentifier:@"NewsDetail"];
    controller.url=urlString;
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(void) collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    //change color when tapped
    UICollectionViewCell *cell = [collectionView
                                  dequeueReusableCellWithReuseIdentifier:@"NewsCell"
                                  forIndexPath:indexPath];
    cell.layer.borderColor =  [UIColor whiteColor].CGColor;
}






- (IBAction)more:(id)sender {
    
    self.tabBarController.selectedIndex = 1;
    
}


-(void)viewDidAppear:(BOOL)animated{
    [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:@"Home"];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:@" "];
    [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:@" "];
}

@end
