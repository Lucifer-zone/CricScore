//
//  RecentMatchesTable.m
//  CricScore
//
//  Created by Shubham Sharma on 29/06/17.
//  Copyright © 2017 Shubham Sharma. All rights reserved.
//

#import "RecentMatchesTable.h"
#import "RecentMatchesTableViewCell.h"
#import "CommentaryWebView.h"

@interface RecentMatchesTable ()
{
    NSMutableArray *MatchId;
    NSMutableArray *Team1;
    NSMutableArray *Team2;
    NSMutableArray *Team1Score;
    NSMutableArray *Team2Score;
    NSMutableArray *matchTitle;
    NSMutableArray *Team1SecondInn;
    NSMutableArray *Team2SecondInn;
    NSMutableArray *newMatchId;
    NSMutableArray *Runrate1;
    NSMutableArray *Runrate2;
    NSMutableArray *ov1;
    NSMutableArray *ov2;
    RecentMatchesTableViewCell *cell;
}
-(void)ConnectionPart;
-(void)UseMatchId;
-(void)noMatches;
@end

@implementation RecentMatchesTable
NSString *Api_key3=@"?apikey=dedcqTtSxWfBfaG2OgfXU6b3zEU2";

int ct=5;

- (void)viewDidLoad {
    [super viewDidLoad];
    //Load Nib
       UINib *cellNib = [UINib nibWithNibName:@"RecentMatchesTableViewCell" bundle:nil];
    [_recentTable registerNib:cellNib forCellReuseIdentifier:@"RecentMatches"];
    
    //Background
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BACKGROUND.jpg"]];
    [tempImageView setFrame:_recentTable.frame];
    _recentTable.backgroundColor = [UIColor clearColor];
    _recentTable.backgroundView = tempImageView;
    _recentTable.opaque=NO;
    
    
    
    //Tab Bar Control
    [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:@""];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:@"Recents"];
    [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:@" "];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    
    
    MatchId = [NSMutableArray new];
    Team1 = [NSMutableArray new];
    Team2 = [NSMutableArray new];
    Team1Score = [NSMutableArray new];
    Team2Score = [NSMutableArray new];
    Team1SecondInn = [NSMutableArray new];
    Team2SecondInn = [NSMutableArray new];
    matchTitle = [NSMutableArray new];
    newMatchId = [NSMutableArray new];
   // [self ConnectionPart];
}

-(void)ConnectionPart
{
    [_loading3 startAnimating];
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlstring = @"http://cricapi.com/api/matches";
    NSString *addkey = [NSString stringWithFormat:@"%@%@",urlstring,Api_key3];
    
    NSURL *url = [NSURL URLWithString:addkey];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSMutableArray *newMatches = [NSMutableArray new];
        newMatches=[json objectForKey:@"matches"];
        NSLog(@"----not usual JSON--%@----",newMatches);
        NSString *team1name = [NSString new];
        for(int i=0;i<newMatches.count;i++){
            team1name = [newMatches[i] valueForKey:@"team-1"];
            if([[newMatches[i] valueForKey:@"matchStarted"] isEqual:@true]) {
            NSString *a = [newMatches[i] valueForKey:@"unique_id"];
            [MatchId addObject:[NSString stringWithFormat:@"%@",a]];
            //&& [UIImage imageNamed:team1name]!=NULL)
        }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if(MatchId.count!=0){
            [self UseMatchId];
            }
            else{
                [self noMatches];
            }
        });

    }
    ];
    
    [dataTask resume];
   
   
    NSLog(@"###count of matchid--%@----",MatchId);

}
-(void)UseMatchId{
    //Use MatchId
    if(MatchId.count!=0){
       
        NSURLSession *session2 = [NSURLSession sharedSession];
        NSString *urlstring2 = @"http://cricapi.com/api/fantasySummary";
        for(int i=0;i<MatchId.count;i++)
        {
        NSString *useMatchid = [NSString stringWithFormat:@"&unique_id=%@",MatchId[i]];
        NSString *addkey2=[NSString stringWithFormat:@"%@%@%@",urlstring2,Api_key3,useMatchid];
        
        NSURL *url2 = [NSURL URLWithString:addkey2];
        
        NSLog(@"%@",url2);
        NSURLSessionDataTask *dataTask2 = [session2 dataTaskWithURL:url2 completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
            NSDictionary *json2 = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
           
            NSLog(@"json recent %@",json2);
            [matchTitle addObject:[json2 valueForKey:@"type"]];

            NSMutableArray *sumdata = [NSMutableArray new];
            sumdata=[ json2 objectForKey:@"data"];
         
            NSMutableArray *sumbatting = [NSMutableArray new];
            
            sumbatting=[ sumdata valueForKey:@"batting"];
            if(sumbatting.count!=0){
             NSMutableArray *teamdata = [NSMutableArray new];
            teamdata=[sumbatting valueForKey:@"title"];
            NSLog(@"---Teamdata--%@",teamdata);
            NSString *team1data =[[[teamdata[0] stringByReplacingOccurrencesOfString:@" 1st" withString:@""]stringByReplacingOccurrencesOfString:@" 2nd" withString:@""]stringByReplacingOccurrencesOfString:@" innings" withString:@""];
            NSLog(@"dfdjf %@",team1data);
            [Team1 addObject:[team1data stringByReplacingOccurrencesOfString:@" team" withString:@""]];
            
            NSString *team2data = [[[teamdata[1] stringByReplacingOccurrencesOfString:@" 1st" withString:@""]stringByReplacingOccurrencesOfString:@" 2nd" withString:@""]stringByReplacingOccurrencesOfString:@" innings" withString:@""];
            [Team2 addObject:[team2data stringByReplacingOccurrencesOfString:@" team" withString:@""]];
            NSLog(@"---Team1--%@",Team1);
            NSLog(@"---Team2--%@",Team2);
            
            NSMutableArray *sumScore = [NSMutableArray new];
            sumScore=[ sumbatting[0] valueForKey:@"scores"];
                if(sumScore!=NULL){
            bool found=false;
            NSMutableArray *array = [NSMutableArray new];
            NSString *scoreTeam1 = [NSString new];
 NSString *overshelp = [NSString new];
            for(int i=0;i<sumScore.count;i++)
            {
                if([[sumScore[i] valueForKey:@"batsman"] isEqual:@"Total"])
                {
                    found = true;
                    
                    scoreTeam1 = [sumScore[i] valueForKey:@"R"];
                    NSLog(@"Runs----%@",scoreTeam1);
                    NSString *runR =  [sumScore[i] valueForKey:@"M"];
                    [Runrate1 addObject:[NSString stringWithFormat:@"R.R: %@",[runR substringWithRange:NSMakeRange(1, 4)]]];
                    NSString *str = [sumScore[i] valueForKey:@"dismissal-info"];
                    NSLog(@"%@",str);
                    for (int i = 0; i < [str length]; i++) {
                        NSString *ch = [str substringWithRange:NSMakeRange(i, 1)];
                        
                        if([ch isEqual:@";"]){
                            overshelp = [str substringWithRange:NSMakeRange(i+2, 3)];
                            [ov1 addObject:[NSString stringWithFormat:@"Overs:%@",overshelp]];
                        }

                        [array addObject:ch];
                    }
                    NSLog(@"Wickets----%@",array[1]);
                }
                
            }
           NSLog(@"%@",array[1]);
            NSString *wickets1 = @"";
            if(![array[1] isEqual:@"a"]){
                wickets1=[NSString stringWithFormat:@"/%@",array[1]];
                NSLog(@"%@",wickets1);
            }
            [Team1Score addObject:[NSString stringWithFormat:@"%@%@",scoreTeam1,wickets1]];
            NSLog(@"Team 1 Score%@",Team1Score);

            //for second team
            NSMutableArray *sumScore2 = [NSMutableArray new];
            sumScore2=[ sumbatting[1] valueForKey:@"scores"];
            NSLog(@"%@",sumScore2);
            if(sumScore2!=NULL){
                
                bool found2=false;
                NSMutableArray *array2 = [NSMutableArray new];
                NSString *overshelp = [NSString new];
                NSString *scoreTeam2 = [NSString new];
                for(int i=0;i<sumScore2.count;i++)
                {
                    if([[sumScore2[i] valueForKey:@"batsman"] isEqual:@"Total"])
                    {
                        found2 = true;
                        
                        scoreTeam2 = [sumScore2[i] valueForKey:@"R"];
                        NSLog(@"Second Runs----%@",scoreTeam2);
                        NSString *runR = [sumScore2[i] valueForKey:@"M"];
                        [Runrate2 addObject:[NSString stringWithFormat:@"R.R: %@",[runR substringWithRange:NSMakeRange(1, 4)]]];
                        
                        NSString *str2 = [sumScore2[i] valueForKey:@"dismissal-info"];
                        for (int i = 0; i < [str2 length]; i++) {
                            NSString *ch2 = [str2 substringWithRange:NSMakeRange(i, 1)];
                            
                            if([ch2 isEqual:@";"]){
                                overshelp=[str2 substringWithRange:NSMakeRange(i+2, 3)];
                                [ov2 addObject:[NSString stringWithFormat:@"Overs:%@",overshelp]];
                            }
                            [array2 addObject:ch2];
                        }
                        NSLog(@"Second Wickets----%@",array2[1]);
                    }
                }
                NSString *wickets2 = @"";
                if(![array2[1] isEqual:@"a"]){
                    wickets2 = [NSString stringWithFormat:@"/%@",array2[1]];
                }
                [ Team2Score addObject:[NSString stringWithFormat:@"%@%@",scoreTeam2,wickets2]];
                NSLog(@"Team 2 Score%@",Team2Score);
                
            }
            else{
                [Team2Score addObject:@" "];
            }
            NSLog(@"--no. of innings--%lu",(unsigned long)sumbatting.count);
            
            
            //Second Inn Team1
            if(sumbatting.count>2)
            {
            NSMutableArray *sumScore3=[NSMutableArray new];
            
            sumScore3=[ sumbatting[2] valueForKey:@"scores"];
            NSLog(@"%@",sumScore3);
            if(sumScore3!=NULL){
                
                bool found3=false;
                NSMutableArray *array3 = [NSMutableArray new];
                NSString *scoreTeam3=[NSString new];
                for(int i=0;i<sumScore3.count;i++)
                {
                    if([[sumScore3[i] valueForKey:@"batsman"] isEqual:@"Total"])
                    {
                        found3=true;
                        
                        scoreTeam3=[sumScore3[i] valueForKey:@"R"];
                        NSLog(@"Second Runs----%@",scoreTeam3);
                        
                        
                        NSString *str3 = [sumScore3[i] valueForKey:@"dismissal-info"];
                        for (int i = 0; i < [str3 length]; i++) {
                            NSString *ch2 = [str3 substringWithRange:NSMakeRange(i, 1)];
                            [array3 addObject:ch2];
                        }
                        NSLog(@"Second Wickets----%@",array3[1]);
                    }
                }
                NSString *wickets3=@"";
                if(![array3[1] isEqual:@"a"]){
                    wickets3=[NSString stringWithFormat:@"/%@",array3[1]];
                }
                [ Team1SecondInn addObject:[NSString stringWithFormat:@"%@%@",scoreTeam3,wickets3]];
                NSLog(@"Team 3 Score%@",Team1SecondInn);
                
            }else{
                [Team1SecondInn addObject:@" "];
            }
                       }
            else{
                [Team1SecondInn addObject:@" "];
            }

                if(sumbatting.count>3)
                {
                    
            //Second Inn Team2
             NSMutableArray *sumScore4=[NSMutableArray new];
        
            sumScore4=[ sumbatting[3] valueForKey:@"scores"];
            NSLog(@"%@",sumScore4);
            if(sumScore4!=NULL){
                
                bool found4=false;
                NSMutableArray *array4 = [NSMutableArray new];
                NSString *scoreTeam4=[NSString new];
                for(int i=0;i<sumScore4.count;i++)
                {
                    if([[sumScore4[i] valueForKey:@"batsman"] isEqual:@"Total"])
                    {
                        found4=true;
                        
                        scoreTeam4=[sumScore4[i] valueForKey:@"R"];
                        NSLog(@"Second Runs----%@",scoreTeam4);
                        
                        NSString *str4 = [sumScore4[i] valueForKey:@"dismissal-info"];
                        for (int i = 0; i < [str4 length]; i++) {
                            NSString *ch2 = [str4 substringWithRange:NSMakeRange(i, 1)];
                            [array4 addObject:ch2];
                        }
                        NSLog(@"Second Wickets----%@",array4[1]);
                    }
                }
                NSString *wickets4=@"";
                if(![array4[1] isEqual:@"a"]){
                    wickets4=[NSString stringWithFormat:@"/%@",array4[1]];
                }
                [ Team2SecondInn addObject:[NSString stringWithFormat:@"%@%@",scoreTeam4,wickets4]];
                NSLog(@"Team 4 Score%@",Team2SecondInn);
            }
            else{
                [Team2SecondInn addObject:@" "];
            }
            }
                else{
                    [Team2SecondInn addObject:@" "];
                }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [_recentTable reloadData];
                [_loading3 stopAnimating];
                _loading3.hidesWhenStopped=@true;
            });
            }
                else{
                    [Team1Score addObject:@" "];
                    [Team2Score addObject:@" "];
                    [Team1SecondInn addObject:@" "];
                    [Team2SecondInn addObject:@" "];
                }
            }
            else{
                [Team1Score addObject:@" "];
                [Team2Score addObject:@" "];
                [Team1SecondInn addObject:@" "];
                [Team2SecondInn addObject:@" "];
            }
        }];
        
        [dataTask2 resume];
            [newMatchId addObject:MatchId[i]];
            }
    }
    
 // while(Team1Score.count==0 ){
    
//NSLog(@"-----now i know---");
 //  }
    NSLog(@"%@",Team1Score);
   
}
-(void)noMatches{
   
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Failure"
                                  message:@"Password not identical"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [self dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
                             [alert addAction:ok];

  
    [_loading3 stopAnimating];
    [_loading3 setHidesWhenStopped:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

 //   return ;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"tell me ###%lu ",(unsigned long)Team1Score.count);
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cell = (RecentMatchesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RecentMatches"];
    /*cell.matchType.text=[matchTitle objectAtIndex:indexPath.row];
    cell.teamOneFirstInn.text=[Team1Score objectAtIndex:indexPath.row];
   
       cell.teamTwoFirstInn.text=[Team2Score objectAtIndex:indexPath.row];
    
       cell.teamOne.text=[Team1 objectAtIndex:indexPath.row];
    cell.teamTwo.text=[Team2 objectAtIndex:indexPath.row];
 //   cell.teamOneLogo.image=[UIImage imageNamed:cell.teamOne.text];
   // cell.teamTwoLogo.image=[UIImage imageNamed:cell.teamTwo.text];
  ;
    NSLog(@" --checking 2nd INN--%@",[Team1SecondInn objectAtIndex:indexPath.row]);
    cell.teamOneSecondInn.text=[Team1SecondInn objectAtIndex:indexPath.row];
    
    cell.teamTwoSecondInn.text=[Team2SecondInn objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    cell.teamOne.textColor=[UIColor whiteColor];
    cell.teamTwo.textColor=[UIColor whiteColor];
    cell.teamOneFirstInn.textColor=[UIColor whiteColor];
    cell.teamTwoFirstInn.textColor=[UIColor whiteColor];
    cell.Runrate1.text=[Runrate1 objectAtIndex:indexPath.row];
     cell.Runrate2.text=[Runrate2 objectAtIndex:indexPath.row];
     cell.ov1.text=[ov1 objectAtIndex:indexPath.row];
     cell.ov2.text=[ov2 objectAtIndex:indexPath.row];
    */
    cell.backgroundColor=[UIColor clearColor];
            return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentaryWebView * controller = [storyboard instantiateViewControllerWithIdentifier:@"CommentaryWebView"];
    //controller.matchid=[newMatchId objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
   }


-(void)viewDidAppear:(BOOL)animated{
    [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:@" "];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:@"Recents"];
    [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:@""];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
