//
//  DetailsViewController.h
//  PianoPushPlay
//
//  Created by James Stiehl on 2/1/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController
@property NSString *annotationTitle;
@property UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *pianoImageView;
@property (weak, nonatomic) IBOutlet UIView *bioView;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) NSString *bio;
@property (weak, nonatomic) NSString *pianoTitle;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;

@end
