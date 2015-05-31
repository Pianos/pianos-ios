//
//  WebViewController.h
//  PianoPushPlay
//
//  Created by Misty DeGiulio on 4/29/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *viewWeb;
@property (weak, nonatomic) NSString *pianourl;
@end
