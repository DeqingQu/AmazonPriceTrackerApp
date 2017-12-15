//
//  AmazonDetailViewController.m
//  AmazonPriceTrackerApp
//
//  Created by Alex on 12/15/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AmazonDetailViewController.h"

@interface AmazonDetailViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AmazonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_c_url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
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
