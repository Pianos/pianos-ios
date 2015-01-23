//
//  HttpModule.m
//  CareRingProfile
//
//  Created by James Stiehl on 1/15/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import "HttpModule.h"

@implementation HttpModule

-(void)httpRequest: (NSString *)path requestMethod:(NSString *)method reqData:(NSData *)reqData {
    
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
    
    if(method == nil){
       request.HTTPMethod = @"GET";
    } else {
      request.HTTPMethod = method;
    }
    
    if(reqData == nil){
        NSLog(@"No data!  Must be a get request!");
    } else {
        NSLog(@"Setting request body");
        NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:reqData options:NSJSONReadingMutableContainers error:nil]);
        [request setHTTPBody:reqData];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    connection = [NSURLConnection connectionWithRequest:request delegate:self];

}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"Response received!");
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@", error);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{

    // This is where I will add post my notification and include the data to send back to the app delegate
    json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"%@", json);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"httpDataReceived" object:json];
}


@end
