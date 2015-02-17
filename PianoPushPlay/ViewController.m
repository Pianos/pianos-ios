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
    UITabBarController *tabBarController;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
      tabBarController = (UITabBarController *) self.tabBarController;;
      tabBarController.tabBar.backgroundColor = [UIColor blackColor];
      tabBarController.tabBar.tintColor = [UIColor blackColor];
    
//    [[self navigationController] navigationBar].backgroundColor = [UIColor blackColor];
//    [[self navigationController] navigationBar].tintColor = [UIColor blackColor];
//    [[self navigationController] navigationBar].alpha = 1.0;
    
    // Do any additional setup after loading the view, typically from a nib.
    self.composeButton.enabled = FALSE;
    
    imageArray = [[NSMutableArray alloc] init];
    
    CLLocationCoordinate2D portland = CLLocationCoordinate2DMake(45.5241, -122.676201);
    
    MKCoordinateSpan span = MKCoordinateSpanMake(.05, .05);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(portland, span);
    
    self.pianoMap.delegate = self;
    
    [self.pianoMap setRegion:region animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pianoDataReceived:) name:@"httpDataReceived"  object:nil];
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

    
//    int i;
//    NSLog(@"%@", [[mapView.annotations objectAtIndex:0] pianoImage]);
//    if ([view.annotation.title  isEqual: @"Stark Piano"]) {
//        i=0;
//    } else if ([view.annotation.title  isEqual: @"Salmon Springs Piano"]){
//        i =1;
//    } else if ([view.annotation.title  isEqual: @"SW 5th Piano"]){
//        i = 2;
//    } else if ([view.annotation.title  isEqual: @"SW Madison Piano"]){
//        i = 3;
//    } else if([view.annotation.title  isEqual: @"Pioneer Square Piano"]){
//        i = 4;
//    } else {
//        i = 5;
//    }
//    self.pictureView.image = [imageArray objectAtIndex:i];
    
   
//    PianoAnnotations *pianoAnnotation = view.annotation;
//    [self performSegueWithIdentifier:@"detailSeg" sender:pianoAnnotation];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"detailSeg"])
    {
        PianoAnnotations *detAnnot = sender;
        DetailsViewController *vc = [segue destinationViewController];
        vc.image = detAnnot.pianoImage;
        vc.hidesBottomBarWhenPushed = YES;
    }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    self.pictureView.image = nil;
}

-(void)pianoDataReceived: (NSNotification *) notification {
    
    NSDictionary *json = [notification object];
    
    NSLog(@"%@", json);
    
    //Place annotations for each piano on map after receiving the data from server
    for (id key in json){
        NSDictionary *object = [json objectForKey:key];
        NSString *title = [object objectForKey:@"title"];
        NSString *imageName = [object objectForKey:@"image"];
        NSNumber *lat = [object objectForKey:@"lat"];
        NSNumber *lon = [object objectForKey:@"lon"];
        CLLocationCoordinate2D pianoCord = CLLocationCoordinate2DMake(lat.doubleValue, lon.doubleValue);
        UIImage *image = [UIImage imageNamed:imageName];
        [self showAnnotation:pianoCord title:title image:image];
    }
    
    
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    static NSString *identifier = @"MyLocation";
    
    if ([annotation isKindOfClass:[PianoAnnotations class]]) {
        
        MKAnnotationView *aView = (MKAnnotationView *) [self.pianoMap dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (aView == nil) {
            aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
            aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            aView.canShowCallout = YES;
            aView.annotation = annotation;
        } else {
            aView.annotation = annotation;
        }
        
        return aView;
        
    } else {
        return nil;
    }
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    PianoAnnotations *pianoAnnotation = view.annotation;
    [self performSegueWithIdentifier:@"detailSeg" sender:pianoAnnotation];
    
}

@end
