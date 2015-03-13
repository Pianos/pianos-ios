//
//  showqrViewController.h
//  PianoPushPlay
//
//  Created by Misty DeGiulio on 2/22/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface showqrViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *showqrwebview;

@property NSURLRequest *qrrequest;

@end
