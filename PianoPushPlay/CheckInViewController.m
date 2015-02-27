//
//  CheckInViewController.m
//  PianoPushPlay
//
//  Created by Misty DeGiulio on 2/22/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import "CheckInViewController.h"
#import "QRCodeReaderViewController.h"
#import "showqrViewController.h"


@interface CheckInViewController ()

@end

@implementation CheckInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)scanAction:(id)sender {
    
    
    //Make sure you have imported the "QRCodeReaderViewController" folder from this project into your own and add the #import "QRCodeReaderViewController.h" to the top of the ViewController where you need to create this QRCodeReaderViewController
    //Create the controller. (new) is just a shortcut for alloc and init.
    QRCodeReaderViewController *reader = [QRCodeReaderViewController new];
    reader.modalPresentationStyle = UIModalPresentationFormSheet;
    // this has a completion block that will return the QR code info. The QRCodeReaderViewController can also be set to share its result using a delegate method instead of using blocks and a completion handler.
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            
            NSLog(@"%@", resultAsString);
            
            
            NSString *fullURL = resultAsString;
            NSURL *url = [NSURL URLWithString:fullURL];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
           // [_qrWebView loadRequest:requestObj];
            
            [self performSegueWithIdentifier:@"qrsegway" sender:requestObj];
            
            //[self performSelector:@selector(loadWebView:) withObject:requestObj afterDelay:.1];
            
            
        }];
        
    }];
    [self presentViewController:reader animated:YES completion:NULL];
    

}

-(void) loadWebView:(NSURLRequest *)request {
     [self performSegueWithIdentifier:@"qrsegway" sender:request];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"qrsegway"]){
        NSURLRequest *urlrequest = (NSURLRequest *)sender;
        showqrViewController *qrsend = [segue destinationViewController];
        
        qrsend.qrrequest = urlrequest;
        
        
    }
    
}






- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    
      NSLog(@"Did get in here");
    [self dismissViewControllerAnimated:YES completion:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}



@end