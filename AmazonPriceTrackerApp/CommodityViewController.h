//
//  CommodityViewController.h
//  AmazonPriceTrackerApp
//
//  Created by Alex on 11/17/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommodityViewController : UIViewController

@property (assign, nonatomic) NSInteger c_id;
@property (copy, nonatomic) NSString *c_title;
@property (copy, nonatomic) NSString *c_url;

@end
