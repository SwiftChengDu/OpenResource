//
//  AVCamUtilities.h
//  Connection
//
//  Created by 杨涵 on 16/4/13.
//  Copyright © 2016年 yanghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVCaptureConnection;

@interface AVCamUtilities : NSObject

+ (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromeConnections:(NSArray *)connections;

@end
