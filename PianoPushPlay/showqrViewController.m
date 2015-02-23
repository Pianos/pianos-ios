//
//  showqrViewController.m
//  PianoPushPlay
//
//  Created by Misty DeGiulio on 2/22/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import "showqrViewController.h"

@interface showqrViewController ()

@end

@implementation showqrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_showqrwebview loadRequest:self.qrrequest];
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

@end
