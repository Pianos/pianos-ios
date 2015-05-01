//
//  DetailsViewController.h
//  PianoPushPlay
//
//  Created by James Stiehl on 2/1/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLImageEditor.h"

@interface DetailsViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate>
@property NSString *annotationTitle;
@property NSString *image;
@property (weak, nonatomic) IBOutlet UIImageView *pianoImageView;
@property (weak, nonatomic) IBOutlet UIView *bioView;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) NSString *bio;
@property (weak, nonatomic) NSString *pianoUrl;
@property (weak, nonatomic) NSString *pianoTitle;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;

@property UIImage *selfie;

@property (nonatomic, retain) NSString *pianoName;
@property (strong, nonatomic)  UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIImageView *selfieImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkinbutton;

@end
