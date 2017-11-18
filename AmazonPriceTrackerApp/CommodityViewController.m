//
//  CommodityViewController.m
//  AmazonPriceTrackerApp
//
//  Created by Alex on 11/17/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "CommodityViewController.h"
#import "AFNetworking.h"

@interface CommodityViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSString *c_title;
@property (strong, nonatomic) NSMutableArray *c_prices;

@end

@implementation CommodityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _c_prices = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self callAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//  private methods
- (void)callAPI {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *URLString = @"http://192.168.0.40:3000/api/commodity/42";
    NSDictionary *parameters = @{};
    
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@", response);
            NSLog(@"%@", responseObject);
            _c_title = [responseObject objectForKey:@"title"];
            NSArray *data = [responseObject objectForKey:@"prices"];
            for(int i=0; i<[data count]; i++) {
                [_c_prices addObject:[data objectAtIndex:i]];
            }
            [_tableView reloadData];
        }
    }];
    [dataTask resume];
}

//  UITableViewDelegate / UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_c_prices count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 68)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    /* Section header is in 0th index... */
    [label setText:_c_title];
    [label setNumberOfLines:0];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0]]; //your background color...
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellID = [NSString stringWithFormat:@"cell_sec_%ld", (long)indexPath.section ];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    float price = [[[_c_prices objectAtIndex:(long)indexPath.row] objectForKey:@"price"] floatValue];
    NSString *date = [[_c_prices objectAtIndex:(long)indexPath.row] objectForKey:@"date"];
    cell.textLabel.text = [NSString stringWithFormat:@"Price - $%.2f", price];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Date - %@", date];
    return cell;
}


@end
