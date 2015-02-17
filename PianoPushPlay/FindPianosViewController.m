//
//  FindPianosViewController.m
//  PianoPushPlay
//
//  Created by James Stiehl on 2/1/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import "FindPianosViewController.h"
#import "AppDelegate.h"

@interface FindPianosViewController ()

@end

@implementation FindPianosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)findPianosButtonPressed:(id)sender {
    
    //make request to website to get piano data and then dismiss view controller
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [myAppDelegate.request httpRequest:@"https://shielded-harbor-4568.herokuapp.com/pianos" requestMethod:nil reqData:nil];
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
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
