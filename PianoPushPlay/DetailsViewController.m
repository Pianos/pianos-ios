//
//  DetailsViewController.m
//  PianoPushPlay
//
//  Created by James Stiehl on 2/1/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Detail View Controller Loaded with image: %@", self.image);
    self.pianoImageView.image = self.image;
    NSLog(@"Height = %f, Width = %f", self.pianoImageView.frame.size.height, self.pianoImageView.frame.size.width);
    self.bioLabel.text = self.pianoTitle;
    self.bioTextView.text = self.bio;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBio)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
}
- (IBAction)dismissBio:(id)sender {
    
    [UIView animateWithDuration:.5 animations:^{
        self.bioView.alpha = 0;
    } completion:^(BOOL finished) {
        self.bioView.hidden = true;
    }];
    
    
}

-(void)showBio{
    
    self.bioView.alpha = 0;
    [UIView animateWithDuration:1 animations:^{
        self.bioView.hidden = FALSE;

    } completion:^(BOOL finished) {
        self.bioView.alpha = 0.8;
    }];
    
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
