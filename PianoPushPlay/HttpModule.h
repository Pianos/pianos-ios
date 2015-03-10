//
//  HttpModule.h
//  CareRingProfile
//
//  Created by James Stiehl on 1/15/15.
//  Copyright (c) 2015 James Stiehl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpModule : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>{
    NSURLConnection *connection;
    NSMutableURLRequest *request;
    NSDictionary *json;
}

-(void)httpRequest: (NSString *)path requestMethod:(NSString *)method reqData:(NSData *)reqData;
@end
