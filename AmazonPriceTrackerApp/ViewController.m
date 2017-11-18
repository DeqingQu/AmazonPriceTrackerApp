//
//  ViewController.m
//  AmazonPriceTrackerApp
//
//  Created by Alex on 11/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    

    NSString *URLString = @"http://192.168.0.40:3000/api/urls";
    NSDictionary *parameters = @{};

    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [dataTask resume];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
