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
#import "ViewController.h"
#import "DetailsViewController.h"

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
            
            
            
            if (resultAsString) {
                
                
                NSLog(@"%@", resultAsString);
                
                //The string is going to be stored somewhere...
                
                UIAlertController *uac = [UIAlertController alertControllerWithTitle:@"Alert" message:@"This is the actual message" preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"Checked in" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    NSLog(@"Alertview dismissed");
                }];
                
                [uac addAction:action];
                
                
                
                [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:NSLocalizedString(@"Checked-In", @"comment")];
                
                
                [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:FALSE];
                
                
                NSLog(@"count: %@",self.navigationController.viewControllers);
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                
                DetailsViewController *ci = [storyboard instantiateViewControllerWithIdentifier:@"checkIn"];
                
                //   DetailsViewController *ci = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 1];
                
                
                
                
                ci.checkinbutton.enabled = FALSE;
                
                
                
                
                
                
                //UIBarButtonItem.Refresh();
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Checking in!"
                                                                    message:@"You have now checked in with this piano."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                
                [alertView show];
                
                
            }
            
            
            
        }];
        
    }];
    [self presentViewController:reader animated:YES completion:NULL];
    
    
}



- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
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