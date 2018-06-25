//
//  UpcomingMatchesTable.m
//  CricScore
//
//  Created by Shubham Sharma on 29/06/17.
//  Copyright © 2017 Shubham Sharma. All rights reserved.
//

#import "UpcomingMatchesTable.h"
#import "UpcomingMatchesTableViewCell.h"
@interface UpcomingMatchesTable ()
{
    NSMutableArray *upcomingMatches;
    NSMutableArray *upcomingMatchesWithImages;
    NSArray *month;
   
}
@end

@implementation UpcomingMatchesTable

  NSString *Api_key2= @"?apikey=dedcqTtSxWfBfaG2OgfXU6b3zEU2";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    month =@[@"not a month",@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"July",@"Aug",@"Sept",@"Oct",@"Nov",@"Dec"];
    //Control TabBar
    
    [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:@" "];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:@" "];
    [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:@"Upcoming"];
    //Load Nib
    UINib *cellNib = [UINib nibWithNibName:@"UpcomingMatchesTableViewCell" bundle:nil];

    [_upcomingTable registerNib:cellNib forCellReuseIdentifier:@"UpcomingMatches"];
    
    //background
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BACKGROUND.jpg"]];
    [tempImageView setFrame:_upcomingTable.frame];
    _upcomingTable.backgroundColor=[UIColor clearColor];
    _upcomingTable.backgroundView = tempImageView;
    _upcomingTable.opaque=NO;
    [self makeConnection];
    
     self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    
}

-(void)makeConnection{
    __block int j = 0;
    [_loading4 startAnimating];
    NSURLSession *session =[NSURLSession sharedSession];
    NSString *urlstring=@"http://cricapi.com/api/matches";
    NSString *addkey=[NSString stringWithFormat:@"%@%@",urlstring,Api_key2];
    
    NSURL *url = [NSURL URLWithString:addkey];
    
    NSURLSessionDataTask *dataTask=[session dataTaskWithURL:url completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        
        NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray *newMatches=[NSMutableArray new];
        newMatches=[json objectForKey:@"matches"];
        upcomingMatches=[NSMutableArray new];
        for(int i=0;i<newMatches.count;i++)
        {
            if([[newMatches[i] valueForKey:@"matchStarted"] isEqual:@false] && [UIImage imageNamed:[newMatches[i] valueForKey:@"team-1"]]!=NULL)
            {
                upcomingMatches[j]=newMatches[i];
                j++;
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
          [_upcomingTable reloadData];
            [_loading4 stopAnimating];
        });
        
    }];
    
    [dataTask resume];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
       return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     NSLog(@"count of images in fun %lu",(unsigned long)upcomingMatches.count);
    return upcomingMatches.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UpcomingMatchesTableViewCell *cell2 = (UpcomingMatchesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UpcomingMatches"];
    cell2.team1.text=[[upcomingMatches objectAtIndex:indexPath.row ]valueForKey:@"team-1"];
    cell2.team2.text=[[upcomingMatches objectAtIndex:indexPath.row ]valueForKey:@"team-2"];
    cell2.team1Logo.image=[UIImage imageNamed:cell2.team1.text];
    cell2.team2Logo.image=[UIImage imageNamed:cell2.team2.text];
    cell2.matchInfo.text=@"One Day International";
    NSArray * arr = [[[upcomingMatches objectAtIndex:indexPath.row]valueForKey:@"date" ] componentsSeparatedByString:@"-"];
    
        NSString *ch = [ arr[2] substringWithRange:NSMakeRange(0, 2)];
    cell2.dateField.text=ch;
    NSLog(@"%@",month[[arr[1] intValue]]);
    cell2.monthfield.text=month[[arr[1] intValue]];
    cell2.backgroundColor=[UIColor clearColor];
   /* cell2.layer.borderWidth = 1.0;
    cell2.layer.borderColor =  [UIColor colorWithRed:0.98 green:0.88 blue:0.87 alpha:1.0].CGColor;

    cell2.layer.cornerRadius = 10;
    cell2.layer.masksToBounds = YES;
  
    cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;*/
        return cell2;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}
-(void)viewDidAppear:(BOOL)animated{
    [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:@" "];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:@" "];
    [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:@"Upcoming"];
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
