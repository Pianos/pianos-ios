//
//  ViewController.m
//  PianoPushPlay
//
//  Created by James Stiehl on 1/20/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import "ViewController.h"
#import "DetailsViewController.h"

@interface ViewController (){
    NSMutableArray *imageArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.composeButton.enabled = FALSE;
    
    imageArray = [[NSMutableArray alloc] init];
    
    CLLocationCoordinate2D portland = CLLocationCoordinate2DMake(45.5241, -122.676201);
    CLLocationCoordinate2D pianoStark = CLLocationCoordinate2DMake(45.519877, -122.654898);
    NSString *starkTitle = @"Stark Piano";
    UIImage *starkImage = [UIImage imageNamed:@"piano2.jpg"];
    
    CLLocationCoordinate2D salmonPiano = CLLocationCoordinate2DMake(45.515329, -122.673618);
    NSString *salmonTitle = @"Salmon Springs Piano";
    UIImage *salmonImage = [UIImage imageNamed:@"piano3.jpg"];
    
    CLLocationCoordinate2D montPiano = CLLocationCoordinate2DMake(45.511464, -122.681496);
    NSString *montTitle = @"SW 5th Piano";
    UIImage *montImage = [UIImage imageNamed:@"piano4.jpg"];
                           
    CLLocationCoordinate2D artPiano = CLLocationCoordinate2DMake(45.516420, -122.682932);
    NSString *artTitle = @"SW Madison Piano";
    UIImage *artImage = [UIImage imageNamed:@"piano5.jpg"];
                               
    CLLocationCoordinate2D pioneerPiano = CLLocationCoordinate2DMake(45.519362, -122.679611);
    NSString *pioneerTitle = @"Pioneer Square Piano";
    UIImage *pioneerImage = [UIImage imageNamed:@"piano6.jpg"];
                               
    CLLocationCoordinate2D burnPiano = CLLocationCoordinate2DMake(45.522925, -122.684079);
    NSString *burnTitle = @"Burnside Piano";
    UIImage *burnImage = [UIImage imageNamed:@"piano7.jpg"];
                               
    MKCoordinateSpan span = MKCoordinateSpanMake(.05, .05);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(portland, span);
    
    self.pianoMap.delegate = self;
    
    [self.pianoMap setRegion:region animated:YES];
    [self showAnnotation:pianoStark title:starkTitle image:starkImage];
    [self showAnnotation:salmonPiano title:salmonTitle image:salmonImage];
    [self showAnnotation:montPiano title:montTitle image:montImage];
    [self showAnnotation:artPiano title:artTitle image:artImage];
    [self showAnnotation:pioneerPiano title:pioneerTitle image:pioneerImage];
    [self showAnnotation:burnPiano title:burnTitle image:burnImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)showAnnotation:(CLLocationCoordinate2D) coordinate title:(NSString *)title image:(UIImage *) image{
    
    PianoAnnotations *annotation = [[PianoAnnotations alloc] initWithTitle:title andCoordinate:coordinate andImage:image];
    [imageArray addObject:annotation.pianoImage];
    [self.pianoMap addAnnotation:annotation];
    
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    int i;
    NSLog(@"%@", [[mapView.annotations objectAtIndex:0] pianoImage]);
    if ([view.annotation.title  isEqual: @"Stark Piano"]) {
        i=0;
    } else if ([view.annotation.title  isEqual: @"Salmon Springs Piano"]){
        i =1;
    } else if ([view.annotation.title  isEqual: @"SW 5th Piano"]){
        i = 2;
    } else if ([view.annotation.title  isEqual: @"SW Madison Piano"]){
        i = 3;
    } else if([view.annotation.title  isEqual: @"Pioneer Square Piano"]){
        i = 4;
    } else {
        i = 5;
    }
    self.pictureView.image = [imageArray objectAtIndex:i];
    
   
    PianoAnnotations *pianoAnnotation = view.annotation;
    [self performSegueWithIdentifier:@"detailSeg" sender:pianoAnnotation];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"detailSeg"])
    {
        PianoAnnotations *detAnnot = sender;
        DetailsViewController *vc = [segue destinationViewController];
        vc.image = detAnnot.pianoImage;
    }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    self.pictureView.image = nil;
}

@end
