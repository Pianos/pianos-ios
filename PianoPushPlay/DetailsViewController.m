//
//  DetailsViewController.m
//  PianoPushPlay
//
//  Created by James Stiehl on 2/1/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import "DetailsViewController.h"
//#import "AppDelegate.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.pianoName isEqualToString:@"Piano2"])
    {
        
   //     NSLog(@"I got into the Piano2 logic!");
  //    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
 //     [myAppDelegate.request httpRequest:@"https://shielded-harbor-4568.herokuapp.com/pianos" requestMethod:nil reqData:nil];
        
   //    PianoAnnotations *detAnnot = ;
  //      DetailsViewController *vc = [segue destinationViewController];
   //     self.image = artPiano.pianoImage;
  //      vc.pianoTitle = detAnnot.title;
  //      vc.bio = detAnnot.bio;
  //      vc.hidesBottomBarWhenPushed = YES;
        
        
        self.image = [UIImage imageNamed: @"piano2.jpg"];
        self.pianoTitle = @"Stark Piano";
        self.bio = @"The first piano to find a home! Not really a public piano, but you can play it when you are at the wonderful ADX facility. 417 SE 11th Ave. Go on in and give it a try! Open during ADX hours";
        self.hidesBottomBarWhenPushed = YES;
               
    }
    
 
    
    // Do any additional setup after loading the view.
    NSLog(@"Detail View Controller Loaded with image: %@", self.image);
    
    NSLog(@"Piano Name: %@", self.pianoName);
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
