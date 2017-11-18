//
//  ViewController.m
//  AmazonPriceTrackerApp
//
//  Created by Alex on 11/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

#import "CommodityViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *commodity_urls;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _commodity_urls = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self callAPI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//  private methods
- (void)callAPI {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *URLString = @"http://192.168.0.40:3000/api/urls";
    NSDictionary *parameters = @{};
    
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@", response);
            NSLog(@"%@", [responseObject objectForKey:@"data"]);
            NSArray *data = [responseObject objectForKey:@"data"];
            for(int i=0; i<[data count]; i++) {
                [_commodity_urls addObject:[data objectAtIndex:i]];
            }
            [_tableView reloadData];
        }
    }];
    [dataTask resume];
}


//  UITableViewDelegate / UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_commodity_urls count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellID = [NSString stringWithFormat:@"cell_sec_%ld", (long)indexPath.section ];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSInteger c_id = [[[_commodity_urls objectAtIndex:(long)indexPath.row] objectForKey:@"c_id"] integerValue];
    NSString *c_url = [[_commodity_urls objectAtIndex:(long)indexPath.row] objectForKey:@"c_url"];
    cell.textLabel.text = [NSString stringWithFormat:@"ID - %ld", c_id];
    cell.detailTextLabel.text = c_url;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"show" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [segue.identifier isEqualToString:@"show"] ) {
        NSIndexPath *indexPath = sender;
        NSInteger c_id = [[[_commodity_urls objectAtIndex:(long)indexPath.row] objectForKey:@"c_id"] integerValue];

        CommodityViewController *c_vc = segue.destinationViewController;
        c_vc.c_id = c_id;
    }
}
    
@end
