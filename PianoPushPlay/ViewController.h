//
//  ViewController.h
//  PianoPushPlay
//
//  Created by James Stiehl on 1/20/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CLImageEditor.h"
#import <CoreLocation/CoreLocation.h>
#import "PianoAnnotations.h"

@interface ViewController : UIViewController <MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *pianoMap;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *composeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;

@end

