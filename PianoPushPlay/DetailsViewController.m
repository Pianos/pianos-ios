//
//  DetailsViewController.m
//  PianoPushPlay
//
//  Created by James Stiehl on 2/1/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import "DetailsViewController.h"
#import "AppDelegate.h"
#import "WebViewController.h"


@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    
    if (self.pianoName) {
        
        //this is a push
        
        //load up a spinner so we have time to grab the correct piano information
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        self.spinner.center = CGPointMake(160, 240);
        self.spinner.tag = 12;
        [self.view addSubview:self.spinner];
        [self.spinner startAnimating];
        
        
        //go get the correct piano information
        AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        // TODO - should this be api.pianopushplay.com ?
        [myAppDelegate.request httpRequest:@"https://ppp-backend.herokuapp.com/pianos" requestMethod:nil reqData:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pianoDataReceived:) name:@"httpDataReceived"  object:nil];
        double delayInSeconds = 2.0;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            NSLog(@"Piano Name: %@", self.pianoName);
            //      self.pianoImageView.image = self.image;
            self.bioLabel.text = self.pianoTitle;
            self.bioTextView.text = self.bio;
            self.pianoUrl = self.pianoUrl;
            NSLog(@"bio: %@", self.bio);
            NSLog(@"url: %@", self.pianoUrl);
            self.bioTextView.editable = false;
            self.bioTextView.selectable = false;
            //  [self viewWillAppear:true];
            
            
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBio)];
            singleTap.numberOfTapsRequired = 1;
            [self.view addGestureRecognizer:singleTap];
            
            //everything is loaded so we can stop the spinner
            [self.spinner stopAnimating];
            //[self.spinner removeFromSuperview];
            
            
        });
        
    }else{
        //This is a normal piano selection
        
        //     self.pianoImageView.image = self.image;
        self.bioLabel.text = self.pianoTitle;
        self.bioTextView.text = self.bio;
        self.pianoUrl = self.pianoUrl;
        NSLog(@"regular bio: %@", self.bioTextView.text);
        NSLog(@"Url: %@", self.pianoUrl);
        
        //   self.bioTextView.editable = false;
        //   self.bioTextView.selectable = false;
        
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBio)];
        singleTap.numberOfTapsRequired = 1;
        [self.view addGestureRecognizer:singleTap];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"webSeg"])
    {
        //         PianoAnnotations *detAnnot = sender;
        WebViewController *vc = [segue destinationViewController];
        
        vc.pianourl = self.pianoUrl;
        NSLog(@"Urlseg: %@", self.pianoUrl);
    }
}




/////////////////////////////////////////
/*
 [super viewDidLoad];
 // Do any additional setup after loading the view.
 NSLog(@"Detail View Controller Loaded with image: %@", self.image);
 
 //self.pianoImageView.image = self.image;
 NSLog(@"Height = %f, Width = %f", self.pianoImageView.frame.size.height, self.pianoImageView.frame.size.width);
 self.bioLabel.text = self.pianoTitle;
 self.bioTextView.text = self.bio;
 self.bioTextView.editable = false;
 self.bioTextView.selectable = false;
 
 UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBio)];
 singleTap.numberOfTapsRequired = 1;
 [self.view addGestureRecognizer:singleTap];
 */


-(void)pianoDataReceived: (NSNotification *) notification {
    
    
    
    NSDictionary *json = [notification object];
    
    //   NSLog(@"%@", json);
    NSLog(@"Piano Name: %@", self.pianoName);
    
    
    //Place annotations for each piano on map after receiving the data from server
    for (id key in json){
        
        //   NSLog(@"key: %@", key);
        if ([key isEqualToString:self.pianoName]) {
            
            NSDictionary *object = [json objectForKey:key];
            
            //         NSString *imageName = [object objectForKey:@"image"];
            //         self.image = [UIImage imageNamed:imageName];
            self.pianoTitle = [object objectForKey:@"title"];
            self.bio = [object objectForKey:@"bio"];
            self.hidesBottomBarWhenPushed = YES;
            NSLog(@"I have the Piano data now %@", object);
            self.image = [object objectForKey:@"image"];
            
        }
        
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *imgURL = self.image;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
        
        //set your image on main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pianoImageView setImage:[UIImage imageWithData:data]];
        });
    });
    
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

-(void)viewWillAppear:(BOOL)animated {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *imgURL = self.image;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
        
        //set your image on main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pianoImageView setImage:[UIImage imageWithData:data]];
        });
    });
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
