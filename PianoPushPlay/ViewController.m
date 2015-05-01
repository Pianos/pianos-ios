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
    UITabBarController *tabBarController;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    
    tabBarController = (UITabBarController *) self.tabBarController;;
    tabBarController.tabBar.backgroundColor = [UIColor blackColor];
    tabBarController.tabBar.tintColor = [UIColor blackColor];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.composeButton.enabled = FALSE;
    
    self.pianoMap.showsUserLocation = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pianoDataReceived:) name:@"httpDataReceived"  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)showAnnotation:(CLLocationCoordinate2D) coordinate title:(NSString *)title image:(NSString *) image bio:(NSString *)bio url:(NSString *)url{
    
    PianoAnnotations *annotation = [[PianoAnnotations alloc] initWithTitle:title andCoordinate:coordinate andImage:image andBio:bio andUrl:url];
    [self.pianoMap addAnnotation:annotation];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"detailSeg"])
    {
        PianoAnnotations *detAnnot = sender;
        DetailsViewController *vc = [segue destinationViewController];
        vc.image = detAnnot.pianoImage;
        vc.pianoTitle = detAnnot.title;
        vc.bio = detAnnot.bio;
        vc.pianoUrl = detAnnot.pianoUrl;
        vc.hidesBottomBarWhenPushed = YES;
    }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    self.pictureView.image = nil;
}

-(void)pianoDataReceived: (NSNotification *) notification {
    [self.spinner stopAnimating];
    
    NSDictionary *json = [notification object];
    
    NSLog(@"%@", json);
    NSMutableArray *lats = [[NSMutableArray alloc] init];
    NSMutableArray *longs = [[NSMutableArray alloc] init];
    
    //Place annotations for each piano on map after receiving the data from server
    for (id key in json){
        NSDictionary *object = [json objectForKey:key];
        NSString *title = [object objectForKey:@"title"];
        NSString *imageName = [object objectForKey:@"image"];
        NSNumber *lat = [object objectForKey:@"lat"];
        NSNumber *lon = [object objectForKey:@"lon"];
        NSString *bio = [object objectForKey:@"bio"];
        NSString *pianourl = [object objectForKey:@"url"];
        CLLocationCoordinate2D pianoCord = CLLocationCoordinate2DMake(lat.doubleValue, lon.doubleValue);
        //UIImage *image = [UIImage imageNamed:imageName];
        [self showAnnotation:pianoCord title:title image:imageName bio:bio url:pianourl];
        [longs addObject:lon];
        [lats addObject:lat];
    }
    CLLocationCoordinate2D portland = CLLocationCoordinate2DMake([self center:lats], [self center:longs]);
    MKCoordinateSpan span = MKCoordinateSpanMake(.05, .05);
    MKCoordinateRegion region = MKCoordinateRegionMake(portland, span);
    self.pianoMap.delegate = self;
    [self.pianoMap setRegion:region animated:YES];
    
    
}

-(double)average:(NSMutableArray *)coords{
    
    float average;
    float sum = 0;
    for (int i =0; i< coords.count; i++) {
        NSNumber *tempNum = coords[i];
        sum += tempNum.doubleValue;
    }
    
    average = sum/coords.count;
    NSLog(@"%f", average);
    return average;
}

-(double)center:(NSMutableArray *)coords{
    NSNumber *firstNum = coords[0];
    float average;
    float min = firstNum.doubleValue;
    float max = min;
    for (int i =1; i< coords.count; i++) {
        NSNumber *tempNum = coords[i];
        if (tempNum.doubleValue < min) {
            min = tempNum.doubleValue;
        }
        if (tempNum.doubleValue > max) {
            max = tempNum.doubleValue;
        }
    }
    
    average = (max+min)/2;
    NSLog(@"%f", average);
    return average;
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
            aView.image = [UIImage imageNamed:@"music.png"];
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
    NSLog(@"%@", pianoAnnotation.title);
    [self performSegueWithIdentifier:@"detailSeg" sender:pianoAnnotation];
    
}

@end
