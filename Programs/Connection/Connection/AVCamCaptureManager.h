//
//  AVCamCaptureManager.h
//  Connection
//
//  Created by 杨涵 on 16/4/13.
//  Copyright © 2016年 yanghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol AVCamCaptureManagerDelegate;
@interface AVCamCaptureManager : NSObject

@property (nonatomic, retain) AVCaptureSession *session;
@property (nonatomic, assign) AVCaptureVideoOrientation orientation;

@property (nonatomic, retain) AVCaptureDeviceInput *videoInput;
@property (nonatomic, retain) AVCaptureDeviceInput *audioInput;
@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, assign) id deviceConnectedObserver;
@property (nonatomic, assign) id deviceDisconnectedObserver;
@property (nonatomic, assign) id <AVCamCaptureManagerDelegate> delegate;

- (BOOL) setupSession;
- (void) captureStillImage;
- (BOOL) toggleCamera;
- (NSUInteger) cameraCount;
- (NSUInteger) micCount;
- (void) autoFocusAtPoint:(CGPoint)point;
- (void) continuousFocusAtPoint:(CGPoint)point;

@end

@protocol AVCamCaptureManagerDelegate <NSObject>
@optional
- (void) captureManager:(AVCamCaptureManager *)captureManager didFailWithError:(NSError *)error;
- (void) captureManagerStillImageCaptured:(AVCamCaptureManager *)captureManager;
- (void) captureManagerDeviceConfigurationChanged:(AVCamCaptureManager *)captureManager;

@end