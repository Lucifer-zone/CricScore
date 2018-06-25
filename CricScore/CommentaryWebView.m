//
//  CommentaryWebView.m
//  CricScore
//
//  Created by Shubham Sharma on 10/07/17.
//  Copyright © 2017 Shubham Sharma. All rights reserved.
//

#import "CommentaryWebView.h"

@interface CommentaryWebView ()
{
    NSString *MatchId2;
    NSString *team1name;
    NSString *team2name;
    NSString *score1_1;
    NSString *score2_1;
    NSString *score1_2;
    NSString *score2_2;
    NSString *titleMatch;
    NSString *extra;
    NSString *overs;
    NSString *overfield1;
    NSString *overfield2;
    NSString *runratefield1;
    NSString *runratefiel2;
}

-(void)commentaryConn;
-(void)liveSection;
@end

@implementation CommentaryWebView

NSString *Api_key4 = @"?apikey=dedcqTtSxWfBfaG2OgfXU6b3zEU2";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    MatchId2=[NSString new];
   // MatchId2 = _matchid;
    MatchId2 = _matchid;
    team1name = [NSString new];
    team2name = [NSString new];
    score1_1 = [NSString new];
    score2_1 = [NSString new];
    score1_2 = [NSString new];
    score2_2 = [NSString new];
    titleMatch = [NSString new];
    extra = [NSString new];
    overs = [NSString new];
   // [self commentaryConn];
   // [self liveSection];
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    self.navigationItem.rightBarButtonItem = button;
     self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    //To Auto Refresh
   //[self performSelector:@selector(autorefresh:) withObject:nil afterDelay:30.0f];
}

- (void) refresh:(id)sender
{
    [self viewDidLoad];
}

- (void) autorefresh:(NSTimer*)t
{
    [self viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)commentaryConn{
    [_loading1 startAnimating];
    NSURLSession *session2 = [NSURLSession sharedSession];
    NSString *urlstring2 = @"http://cricapi.com/api/cricketCommentary";
    
    NSString *useMatchid = [NSString stringWithFormat:@"&unique_id=%@",MatchId2];
    NSString *addkey2 = [NSString stringWithFormat:@"%@%@%@",urlstring2,Api_key4,useMatchid];
    
    NSURL *url2 = [NSURL URLWithString:addkey2];
    
   
    NSURLSessionDataTask *dataTask3 = [session2 dataTaskWithURL:url2 completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        NSDictionary *json2 = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString *comm = [json2 objectForKey:@"commentary"];
      
        dispatch_async(dispatch_get_main_queue(), ^{
            [_CommentaryView loadHTMLString:comm baseURL: [[NSBundle mainBundle] bundleURL]];
            [_loading1 stopAnimating];
        });
    }];
    [dataTask3 resume];
}

-(void)liveSection{
    [_loading2 startAnimating];
    //For Results
    NSURLSession *session3 = [NSURLSession sharedSession];
    NSString *urlstring3 = @"http://cricapi.com/api/cricketScore";
    for(int i=0;i<2;i++){
        NSString *useMatchid = [NSString stringWithFormat:@"&unique_id=%@",MatchId2];
        NSString *addkey2 = [NSString stringWithFormat:@"%@%@%@",urlstring3,Api_key4,useMatchid];
        
        NSURL *url2 = [NSURL URLWithString:addkey2];
        
       
        NSURLSessionDataTask *dataTask2 = [session3 dataTaskWithURL:url2 completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
            NSDictionary *json4 = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
           
            
            extra = [json4 objectForKey:@"innings-requirement"];
            
            
        }];
        
        
        
        [dataTask2 resume];
    }


    NSURLSession *session2 = [NSURLSession sharedSession];
    NSString *urlstring2 = @"http://cricapi.com/api/fantasySummary";
           NSString *useMatchid = [NSString stringWithFormat:@"&unique_id=%@",MatchId2];
        NSString *addkey2 = [NSString stringWithFormat:@"%@%@%@",urlstring2,Api_key4,useMatchid];
        
        NSURL *url2 = [NSURL URLWithString:addkey2];
        
              NSURLSessionDataTask *dataTask2 =[session2 dataTaskWithURL:url2 completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
            NSDictionary *json2=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                  NSLog(@"json 2 %@",json2);
         titleMatch= [json2 valueForKey:@"type"];
            
            NSMutableArray *sumdata=[NSMutableArray new];
            sumdata=[ json2 objectForKey:@"data"];
            
            NSMutableArray *sumbatting=[NSMutableArray new];
            sumbatting=[ sumdata valueForKey:@"batting"];
           
            NSMutableArray *teamdata=[NSMutableArray new];
            teamdata=[sumbatting valueForKey:@"title"];
           
            NSString *team1data=[[[teamdata[0] stringByReplacingOccurrencesOfString:@" 1st" withString:@""]stringByReplacingOccurrencesOfString:@" 2nd" withString:@""]stringByReplacingOccurrencesOfString:@" innings" withString:@""];
            
        team1name = [team1data stringByReplacingOccurrencesOfString:@" team" withString:@""];
            
            NSString *team2data = [[[teamdata[1] stringByReplacingOccurrencesOfString:@" 1st" withString:@""]stringByReplacingOccurrencesOfString:@" 2nd" withString:@""]stringByReplacingOccurrencesOfString:@" innings" withString:@""];
            team2name = [team2data stringByReplacingOccurrencesOfString:@" team" withString:@""];
       
            
            NSMutableArray *sumScore = [NSMutableArray new];
            sumScore = [ sumbatting[0] valueForKey:@"scores"];
            bool found = false;
            
            NSString *scoreTeam1 = [NSString new];
                        NSString *wic=[NSString new];
                  
            for(int i=0;i<sumScore.count;i++)
            {
                if([[sumScore[i] valueForKey:@"batsman"] isEqual:@"Total"])
                {
                    found=true;
                    
                    scoreTeam1=[sumScore[i] valueForKey:@"R"];
                    NSString *runR=[sumScore[i] valueForKey:@"M"];
                    runratefield1=[NSString stringWithFormat:@"R.R: %@",[runR substringWithRange:NSMakeRange(1, 4)]];
                    
                    NSString *str = [sumScore[i] valueForKey:@"dismissal-info"];
                  
                  wic= [str substringWithRange:NSMakeRange(1, 1)];
                    NSArray *spaceSeperated=[str componentsSeparatedByString:@" "];
                    overfield1=[NSString stringWithFormat:@"Overs:%@",spaceSeperated[2]];
                    
                }
                
            }
           
            NSString *wickets1=@"";
            if(![wic isEqual:@"a"]){
                wickets1=[NSString stringWithFormat:@"/%@",wic];
               
            }
            score1_1=[NSString stringWithFormat:@"%@%@",scoreTeam1,wickets1];
            
            //SecondTeam
            NSMutableArray *sumScore2=[NSMutableArray new];
                  if([sumbatting[1] valueForKey:@"scores"]!=NULL){
            sumScore2=[ sumbatting[1] valueForKey:@"scores"];
                  
                
                bool found2=false;
                            NSString *scoreTeam2=[NSString new];
                NSString *wic2=[NSString new];
           
                for(int i=0;i<sumScore2.count;i++)
                {
                    if([[sumScore2[i] valueForKey:@"batsman"] isEqual:@"Total"])
                    {
                        found2=true;
                        
                        scoreTeam2=[sumScore2[i] valueForKey:@"R"];
                        
                        NSString *runR=[sumScore2[i] valueForKey:@"M"];
                        runratefiel2=[NSString stringWithFormat:@"R.R: %@",[runR substringWithRange:NSMakeRange(1, 4)]];
                        

                        
                        
                        NSString *str2 = [sumScore2[i] valueForKey:@"dismissal-info"];
                        wic2= [str2 substringWithRange:NSMakeRange(1, 1)];
                        NSArray *spaceSeperated=[str2 componentsSeparatedByString:@" "];
                        overfield2=[NSString stringWithFormat:@"Overs:%@",spaceSeperated[2]];                        }
                    
                    }
                
                NSString *wickets2=@"";
                if(![wic isEqual:@"a"]){
                    wickets2=[NSString stringWithFormat:@"/%@",wic2];
                }
            score2_1=[NSString stringWithFormat:@"%@%@",scoreTeam2,wickets2];
            }
            else{
                 score2_1=@" ";
            }
                  
            //Second Inn Team1
            if(sumbatting.count>2)
            {
                NSMutableArray *sumScore3=[NSMutableArray new];
                
                sumScore3=[ sumbatting[2] valueForKey:@"scores"];
              
                if(sumScore3!=NULL){
                    
                    bool found3=false;
                    
                    NSString *scoreTeam3=[NSString new];
                     NSString *wic3=[NSString new];
                   
                    for(int i=0;i<sumScore3.count;i++)
                    {
                        if([[sumScore3[i] valueForKey:@"batsman"] isEqual:@"Total"])
                        {
                            found3=true;
                            
                            scoreTeam3=[sumScore3[i] valueForKey:@"R"];
                            
                            NSString *runR=[sumScore2[i] valueForKey:@"M"];
                            runratefield1=[NSString stringWithFormat:@"R.R: %@",[runR substringWithRange:NSMakeRange(1, 4)]];
                            NSString *str3 = [sumScore3[i] valueForKey:@"dismissal-info"];
                            wic3= [str3 substringWithRange:NSMakeRange(1, 1)];
                            NSArray *spaceSeperated=[str3 componentsSeparatedByString:@" "];
                            overfield1=[NSString stringWithFormat:@"Overs:%@",spaceSeperated[2]];                     }
                      

                    }
                    NSString *wickets3=@"";
                    if(![wic3 isEqual:@"a"]){
                        wickets3=[NSString stringWithFormat:@"/%@",wic3];
                    }
                    score1_2=[NSString stringWithFormat:@"%@ &",score1_1];
                    score1_1=[NSString stringWithFormat:@"%@%@",scoreTeam3,wickets3];
                   score2_2=[NSString stringWithFormat:@"& %@",score1_2];
                    score2_1=@" ";
                }else{
                   score1_2=@" ";
                }
            }
            else{
                score1_2=@" ";
            }

            
            //Second Inn Team2
            if(sumbatting.count>3)
            {
                NSMutableArray *sumScore4=[NSMutableArray new];
                
                sumScore4=[ sumbatting[3] valueForKey:@"scores"];
              
                if(sumScore4!=NULL){
                    
                    bool found4=false;
                   
                    NSString *scoreTeam4=[NSString new];
                    NSString *wic4=[NSString new];
                    for(int i=0;i<sumScore4.count;i++)
                    {
                        if([[sumScore4[i] valueForKey:@"batsman"] isEqual:@"Total"])
                        {
                            found4=true;
                            
                            scoreTeam4=[sumScore4[i] valueForKey:@"R"];
                            
                            NSString *runR=[sumScore2[i] valueForKey:@"M"];
                            runratefiel2=[NSString stringWithFormat:@"R.R: %@",[runR substringWithRange:NSMakeRange(1, 4)]];
                            
                            NSString *str4 = [sumScore4[i] valueForKey:@"dismissal-info"];
                            wic4= [str4 substringWithRange:NSMakeRange(1, 1)];
                            NSArray *spaceSeperated=[str4 componentsSeparatedByString:@" "];
                            overfield2=[NSString stringWithFormat:@"Overs:%@",spaceSeperated[2]];                                     }
                    NSString *wickets4=@"";
                        if(![wic4 isEqual:@"a"]){
                            wickets4=[NSString stringWithFormat:@"/%@",wic4];
                        }
                   score2_1=[NSString stringWithFormat:@"%@%@",scoreTeam4,wickets4];
                                    }
                }
                else{
                    score2_1=@" ";
                }
            }
            else{
                score2_1=@" ";
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _score11.text=score1_1;
                _oversfield1.text=overs;
                _score21.text=score2_1;
                _score12.text=score1_2;
                _score22.text=score2_2;
                _team1Image.image=[UIImage imageNamed:team1name];
                _team2Image.image=[UIImage imageNamed:team2name];
                _extrainfo.text=extra;
                _oversfield1.text=overfield1;
                _oversfield2.text=overfield2;
                _Runratefield1.text=runratefield1;
                _Runratefield2.text=runratefiel2;
                [_loading2 stopAnimating];
                          });

            
                    }];
    [dataTask2 resume];
    
    }



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
