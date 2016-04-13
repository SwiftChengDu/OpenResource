//
//  AVCamUtilities.m
//  Connection
//
//  Created by 杨涵 on 16/4/13.
//  Copyright © 2016年 yanghan. All rights reserved.
//

#import "AVCamUtilities.h"
#import <AVFoundation/AVFoundation.h>

@implementation AVCamUtilities

+ (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromeConnections:(NSArray *)connections {
    for ( AVCaptureConnection *connection in connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:mediaType]) {
                return connection;
            }
        }
    }
    return nil;
}

@end
