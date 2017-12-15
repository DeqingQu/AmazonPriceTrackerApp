//
//  CommodityViewController.m
//  AmazonPriceTrackerApp
//
//  Created by Alex on 11/17/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "CommodityViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

#import "AmazonDetailViewController.h"

@interface CommodityViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *c_prices;

@end

@implementation CommodityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"Prices";

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
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *URLString = [NSString stringWithFormat:@"%@/api/commodity/%ld", delegate.URL_BASE, _c_id];
    NSDictionary *parameters = @{};
    
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            [self showErrorWithTitle:@"Error Message" withMessage:[error localizedDescription]];
        } else {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            _c_title = [data objectForKey:@"title"];
            NSArray *prices = [data objectForKey:@"prices"];
            for(int i=0; i<[prices count]; i++) {
                [_c_prices addObject:[prices objectAtIndex:i]];
            }
            [_tableView reloadData];
        }
    }];
    [dataTask resume];
}

-(void)showErrorWithTitle:(NSString *)title withMessage:(NSString *)message {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle your yes please button action here
                               }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
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
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    button.backgroundColor = [UIColor lightGrayColor];
    [button addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-40, 40)];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.text = _c_title;
    [button addSubview:label];
    return button;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellID = [NSString stringWithFormat:@"cell_sec_%ld", (long)indexPath.section ];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }

    float price = [[[_c_prices objectAtIndex:(long)indexPath.row] objectForKey:@"price"] floatValue];
    NSString *date = [[_c_prices objectAtIndex:(long)indexPath.row] objectForKey:@"date"];
    cell.textLabel.text = [NSString stringWithFormat:@"Price - $%.2f", price];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Date - %@", date];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)headerClicked:(id)sender {

    [self performSegueWithIdentifier:@"amazon_detail" sender:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [segue.identifier isEqualToString:@"amazon_detail"] ) {
    
        AmazonDetailViewController *adVC = segue.destinationViewController;
        adVC.c_url = _c_url;
    }
}

@end
