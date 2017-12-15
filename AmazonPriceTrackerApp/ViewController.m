//
//  ViewController.m
//  AmazonPriceTrackerApp
//
//  Created by Alex on 11/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

#import "CommodityViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *commodity_urls;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Home";
    
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
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *URLString = [NSString stringWithFormat:@"%@/api/urls", delegate.URL_BASE];
    NSDictionary *parameters = @{};
    
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            [self showErrorWithTitle:@"Error Message" withMessage:[error localizedDescription]];

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
    return [_commodity_urls count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellID = [NSString stringWithFormat:@"cell_sec_%ld", (long)indexPath.section ];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width - 40, 55)];
        textLabel.tag = 1;
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        textLabel.numberOfLines = 3;
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.textColor = [UIColor darkGrayColor];
        textLabel.font = [UIFont systemFontOfSize:14.0f];
        [cell.contentView addSubview:textLabel];
        
        UILabel *detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, [UIScreen mainScreen].bounds.size.width - 40, 15)];
        detailTextLabel.tag = 2;
        detailTextLabel.textColor = [UIColor grayColor];
        detailTextLabel.font = [UIFont systemFontOfSize:11.0f];
        [cell.contentView addSubview:detailTextLabel];
    }
//    NSInteger c_id = [[[_commodity_urls objectAtIndex:(long)indexPath.row] objectForKey:@"c_id"] integerValue];
    NSString *c_url = [[_commodity_urls objectAtIndex:(long)indexPath.row] objectForKey:@"c_url"];
    NSString *c_title = [[_commodity_urls objectAtIndex:(long)indexPath.row] objectForKey:@"c_title"];
    UILabel *textLabel = [cell viewWithTag:1];
    textLabel.text = c_title;
    
    UILabel *detailTextLabel = [cell viewWithTag:2];
    detailTextLabel.text = c_url;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"commodity" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [segue.identifier isEqualToString:@"commodity"] ) {
        NSIndexPath *indexPath = sender;
        NSInteger c_id = [[[_commodity_urls objectAtIndex:(long)indexPath.row] objectForKey:@"c_id"] integerValue];
        NSString *c_url = [[_commodity_urls objectAtIndex:(long)indexPath.row] objectForKey:@"c_url"];

        CommodityViewController *c_vc = segue.destinationViewController;
        c_vc.c_id = c_id;
        c_vc.c_url = c_url;
    }
}
    
@end
