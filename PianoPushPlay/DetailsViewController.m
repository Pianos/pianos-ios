//
//  DetailsViewController.m
//  PianoPushPlay
//
//  Created by James Stiehl on 2/1/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import "DetailsViewController.h"
#import "AppDelegate.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //if there is not an image loaded from selecting one in the pianos page then
    //this must be a push!
    
    if (!self.image) {
        
        //this is a push
        
        //load up a spinner so we have time to grab the correct piano information
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.center = CGPointMake(160, 240);
        spinner.tag = 12;
        [self.view addSubview:spinner];
        [spinner startAnimating];
        
        
        //go get the correct piano information
        AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [myAppDelegate.request httpRequest:@"https://shielded-harbor-4568.herokuapp.com/pianos" requestMethod:nil reqData:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pianoDataReceived:) name:@"httpDataReceived"  object:nil];
        double delayInSeconds = 3.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        NSLog(@"Piano Name: %@", self.pianoName);
        self.pianoImageView.image = self.image;
        self.bioLabel.text = self.pianoTitle;
        self.bioTextView.text = self.bio;
        self.bioTextView.editable = false;
        self.bioTextView.selectable = false;
            
            
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBio)];
        singleTap.numberOfTapsRequired = 1;
        [self.view addGestureRecognizer:singleTap];
        
        //everything is loaded so we can stop the spinner
        [spinner stopAnimating];
        [spinner removeFromSuperview];
            
            
        });
        
    }else{
        //This is a normal piano selection

        self.pianoImageView.image = self.image;
        self.bioLabel.text = self.pianoTitle;
        self.bioTextView.text = self.bio;
        self.bioTextView.editable = false;
        self.bioTextView.selectable = false;

    
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBio)];
            singleTap.numberOfTapsRequired = 1;
        [self.view addGestureRecognizer:singleTap];
    }
}





-(void)pianoDataReceived: (NSNotification *) notification {
    
    
    [self.spinner removeFromSuperview];
     [self.spinner stopAnimating];
  
    
    NSDictionary *json = [notification object];
    
 //   NSLog(@"%@", json);
    NSLog(@"Piano Name: %@", self.pianoName);

    
    //Place annotations for each piano on map after receiving the data from server
    for (id key in json){
        
     //   NSLog(@"key: %@", key);
        if ([key isEqualToString:self.pianoName]) {
        
        NSDictionary *object = [json objectForKey:key];
 
        NSString *imageName = [object objectForKey:@"image"];
        self.image = [UIImage imageNamed:imageName];
        self.pianoTitle = [object objectForKey:@"title"];
        self.bio = [object objectForKey:@"bio"];
        self.hidesBottomBarWhenPushed = YES;
        NSLog(@"I have the Piano data now %@", object);
            
        }
    }

    
}



- (IBAction)cameraButton:(id)sender {

    [self showCamera];

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

// Adding all the camera stuff here

- (void)savePhoto {
    
    UIImageWriteToSavedPhotosAlbum(self.selfie, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), NULL);
}

-(void)sharePhoto{
    
    UIImage *image = self.selfie;
    NSString *hashTag = @"#PianoPushPlay";
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image, hashTag] applicationActivities:nil];
    [self presentViewController:activityViewController animated:TRUE completion:nil];
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    
    NSString *message;
    
    NSString *titleMessage;
    
    if (!error) {
        message = @"Saved image to library";
        titleMessage = @"Success";
    } else {
        message = @"Error saving image to library";
        titleMessage = @"Error";
    }
    
    UIAlertController *imageAlert = [UIAlertController alertControllerWithTitle:titleMessage message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    
    [imageAlert addAction:okAction];
    
    [self presentViewController:imageAlert animated:YES completion:nil];
}

-(void)showCamera{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    } else {
        UIAlertController *noCamera = [UIAlertController alertControllerWithTitle:@"Camera Error!" message:@"No camera available" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        
        [noCamera addAction:confirm];
        [self presentViewController:noCamera animated:NO completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:chosenImage];
    editor.delegate = self;
    
    [picker pushViewController:editor animated:YES];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image{
    //save image and dismiss editor view
    self.selfie = image;
    [self savePhoto];
    [editor dismissViewControllerAnimated:YES completion:nil];
    
    
    //prompt user if they want to share their photo
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        
        UIAlertView *uav = [[UIAlertView alloc] initWithTitle:@"Sharing" message:@"Would you like to share your photo?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        
        [uav show];
        
        
    } else {
    
        UIAlertController *uac = [UIAlertController alertControllerWithTitle:@"Sharing" message:@"Would you like to share your photo?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self sharePhoto];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"Alertview cancelled");
        }];
        
        [uac addAction:action];
        [uac addAction:cancel];
        
        [self presentViewController:uac animated:true completion:^{
            
        }];
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //Share photo if user clicks yes on the Alert Controller
    [self sharePhoto];
    
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
