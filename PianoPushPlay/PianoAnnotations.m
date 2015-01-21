//
//  PianoAnnotations.m
//  PianoPushPlay
//
//  Created by James Stiehl on 1/20/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import "PianoAnnotations.h"


@implementation PianoAnnotations

-(id)initWithTitle:(NSString *)annotationTitle andCoordinate:(CLLocationCoordinate2D)annotationCoordinate andImage:(UIImage *) image{
    self = [super init];
    if(self){
        
        _title = annotationTitle; //instance variable
        _coordinate = annotationCoordinate; //instance variable
        _pianoImage = image;
        
    }
    
    return self;
}



@end
