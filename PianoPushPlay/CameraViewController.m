//
//  CameraViewController.m
//  PianoPushPlay
//
//  Created by James Stiehl on 2/1/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController{
    UITabBarController *tabBarController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self showCamera];
    tabBarController = (UITabBarController *) self.tabBarController;
    NSLog(@"%@", tabBarController.viewControllers);
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(savePhoto)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(trashPhoto)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sharePhoto)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeRight];
}

-(void)trashPhoto{
    NSLog(@"Swipe Up gesture detected!");
    [self showCamera];
}

- (void)savePhoto {
    
    NSLog(@"double tap detected");
    UIImageWriteToSavedPhotosAlbum(self.selfieImageView.image, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), NULL);
}

-(void)sharePhoto{
    NSLog(@"Swipe Right Detected");
    
    UIImage *image = self.selfie;
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
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
   // [picker dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    tabBarController.selectedViewController = [tabBarController.viewControllers objectAtIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"View will appear");
    
    if(!self.selfie){
      [self showCamera];
    } else {
        NSLog(@"selfie image displayed");
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"View Will Disappear");
    self.selfie = nil;
    self.selfieImageView.image = nil;
}

-(void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image{
    
    //This will turn into an alert asking if user wants to share the image.  if yes, then it will trigger the activity view controller
    
    NSLog(@"Image editing complet");
    self.selfie = image;
    self.selfieImageView.image = image;
    [self.view addSubview:self.selfieImageView];
    [editor dismissViewControllerAnimated:YES completion:nil];
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
