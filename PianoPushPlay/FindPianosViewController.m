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
    
    
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    [[UIImage imageNamed:@"ppp_mainscreen_no_button.jpg"] drawInRect:self.view.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    NSError *setCategoryError = nil;
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    
    if (setCategoryError) {
        NSLog(@"Error setting category! %ld", (long)[setCategoryError code]);
    }
    
    
    NSString *pianoSoundPath = [[NSBundle mainBundle] pathForResource:@"pppshort" ofType:@"wav"];
    NSURL *pianoSoundURL = [NSURL fileURLWithPath:pianoSoundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pianoSoundURL, &_pianoSound);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)findPianos:(id)sender {
    AudioServicesPlaySystemSound(self.pianoSound);
    
    //make request to website to get piano data and then dismiss view controller
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [myAppDelegate.request httpRequest:@"https://ppp-backend.herokuapp.com/pianos" requestMethod:nil reqData:nil];
  //  [myAppDelegate.request httpRequest:@"https://shielded-harbor-4568.herokuapp.com/pianos" requestMethod:nil reqData:nil];
    
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
