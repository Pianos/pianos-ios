//
//  PianoAnnotations.h
//  PianoPushPlay
//
//  Created by James Stiehl on 1/20/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PianoAnnotations : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *pianoImage;
@property (nonatomic, strong) NSString *bio;

-(id)initWithTitle:(NSString *) annotationTitle andCoordinate: (CLLocationCoordinate2D)annotationCoordinate andImage:(NSString *)image andBio:(NSString *)bio;
@end
