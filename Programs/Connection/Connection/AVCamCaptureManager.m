//
//  AVCamCaptureManager.m
//  Connection
//
//  Created by 杨涵 on 16/4/13.
//  Copyright © 2016年 yanghan. All rights reserved.
//

#import "AVCamCaptureManager.h"
#import "AVCamUtilities.h"
#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <ImageIO/CGImageProperties.h>

@interface AVCamCaptureManager (InternalUtilityMethods)
- (void)deviceOrientationDidChange;
- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition)position;
- (AVCaptureDevice *) frontFacingCamera;
- (AVCaptureDevice *) backFacingCamera;
- (AVCaptureDevice *) audioDevice;
- (NSURL *) tempFileURL;
- (void) removeFile:(NSURL *)outputFileURL;
- (void) copyFileToDocuments:(NSURL *)fileURL;
@end

@implementation AVCamCaptureManager

@synthesize session;
@synthesize orientation;
@synthesize videoInput;
@synthesize audioInput;
@synthesize stillImageOutput;
@synthesize deviceConnectedObserver;
@synthesize deviceDisconnectedObserver;
@synthesize delegate;

- (id) init
{
    self = [super init];
    if (self != nil) {
        __block id weakSelf = self;
        void (^deviceConnectedBlock)(NSNotification *) = ^(NSNotification *notification) {
            AVCaptureDevice *device = [notification object];
            
            BOOL sessionHasDeviceWithMatchingMediaType = NO;
            NSString *deviceMediaType = nil;
            if ([device hasMediaType:AVMediaTypeAudio])
                deviceMediaType = AVMediaTypeAudio;
            else if ([device hasMediaType:AVMediaTypeVideo])
                deviceMediaType = AVMediaTypeVideo;
            
            if (deviceMediaType != nil) {
                for (AVCaptureDeviceInput *input in [session inputs])
                {
                    if ([[input device] hasMediaType:deviceMediaType]) {
                        sessionHasDeviceWithMatchingMediaType = YES;
                        break;
                    }
                }
                
                if (!sessionHasDeviceWithMatchingMediaType) {
                    NSError	*error;
                    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
                    if ([session canAddInput:input])
                        [session addInput:input];
                }
            }
            
            if ([delegate respondsToSelector:@selector(captureManagerDeviceConfigurationChanged:)]) {
                [delegate captureManagerDeviceConfigurationChanged:self];
            }
        };
        void (^deviceDisconnectedBlock)(NSNotification *) = ^(NSNotification *notification) {
            AVCaptureDevice *device = [notification object];
            
            if ([device hasMediaType:AVMediaTypeAudio]) {
                [session removeInput:[weakSelf audioInput]];
                [weakSelf setAudioInput:nil];
            }
            else if ([device hasMediaType:AVMediaTypeVideo]) {
                [session removeInput:[weakSelf videoInput]];
                [weakSelf setVideoInput:nil];
            }
            
            if ([delegate respondsToSelector:@selector(captureManagerDeviceConfigurationChanged:)]) {
                [delegate captureManagerDeviceConfigurationChanged:self];
            }
        };
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [self setDeviceConnectedObserver:[notificationCenter addObserverForName:AVCaptureDeviceWasConnectedNotification object:nil queue:nil usingBlock:deviceConnectedBlock]];
        [self setDeviceDisconnectedObserver:[notificationCenter addObserverForName:AVCaptureDeviceWasDisconnectedNotification object:nil queue:nil usingBlock:deviceDisconnectedBlock]];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [notificationCenter addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
        orientation = AVCaptureVideoOrientationPortrait;
    }
    
    return self;
}

- (void) dealloc
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:[self deviceConnectedObserver]];
    [notificationCenter removeObserver:[self deviceDisconnectedObserver]];
    [notificationCenter removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    [[self session] stopRunning];
    [session release];
    [videoInput release];
    [audioInput release];
    [stillImageOutput release];
    
    [super dealloc];
}

- (BOOL) setupSession
{
    BOOL success = NO;
    
    // Set torch and flash mode to auto
    if ([[self backFacingCamera] hasFlash]) {
        if ([[self backFacingCamera] lockForConfiguration:nil]) {
            if ([[self backFacingCamera] isFlashModeSupported:AVCaptureFlashModeAuto]) {
                [[self backFacingCamera] setFlashMode:AVCaptureFlashModeAuto];
            }
            [[self backFacingCamera] unlockForConfiguration];
        }
    }
    if ([[self backFacingCamera] hasTorch]) {
        if ([[self backFacingCamera] lockForConfiguration:nil]) {
            if ([[self backFacingCamera] isTorchModeSupported:AVCaptureTorchModeAuto]) {
                [[self backFacingCamera] setTorchMode:AVCaptureTorchModeAuto];
            }
            [[self backFacingCamera] unlockForConfiguration];
        }
    }
    
    // Init the device inputs
    AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:nil];
    AVCaptureDeviceInput *newAudioInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self audioDevice] error:nil];
    
    
    // Setup the still image file output
    AVCaptureStillImageOutput *newStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    AVVideoCodecJPEG, AVVideoCodecKey,
                                    nil];
    [newStillImageOutput setOutputSettings:outputSettings];
    [outputSettings release];
    
    
    // Create session (use default AVCaptureSessionPresetHigh)
    AVCaptureSession *newCaptureSession = [[AVCaptureSession alloc] init];
    
    
    // Add inputs and output to the capture session
    if ([newCaptureSession canAddInput:newVideoInput]) {
        [newCaptureSession addInput:newVideoInput];
    }
    if ([newCaptureSession canAddInput:newAudioInput]) {
        [newCaptureSession addInput:newAudioInput];
    }
    if ([newCaptureSession canAddOutput:newStillImageOutput]) {
        [newCaptureSession addOutput:newStillImageOutput];
    }
    
    [self setStillImageOutput:newStillImageOutput];
    [self setVideoInput:newVideoInput];
    [self setAudioInput:newAudioInput];
    [self setSession:newCaptureSession];
    
    [newStillImageOutput release];
    [newVideoInput release];
    [newAudioInput release];
    [newCaptureSession release];
    
    success = YES;
    
    return success;
}

- (void) captureStillImage
{
    AVCaptureConnection *stillImageConnection = [AVCamUtilities connectionWithMediaType:AVMediaTypeVideo fromeConnections:[[self stillImageOutput] connections]];
    if ([stillImageConnection isVideoOrientationSupported])
        [stillImageConnection setVideoOrientation:orientation];
    
    [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:stillImageConnection
                                                         completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                             
                                                             ALAssetsLibraryWriteImageCompletionBlock completionBlock = ^(NSURL *assetURL, NSError *error) {
                                                                 if (error) {
                                                                     if ([[self delegate] respondsToSelector:@selector(captureManager:didFailWithError:)]) {
                                                                         [[self delegate] captureManager:self didFailWithError:error];
                                                                     }
                                                                 }
                                                             };
                                                             
                                                             if (imageDataSampleBuffer != NULL) {
                                                                 NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                                 ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                                                                 
                                                                 UIImage *image = [[UIImage alloc] initWithData:imageData];
                                                                 [library writeImageToSavedPhotosAlbum:[image CGImage]
                                                                                           orientation:(ALAssetOrientation)[image imageOrientation]
                                                                                       completionBlock:completionBlock];
                                                                 [image release];
                                                                 
                                                                 [library release];
                                                             }
                                                             else
                                                                 completionBlock(nil, error);
                                                             
                                                             if ([[self delegate] respondsToSelector:@selector(captureManagerStillImageCaptured:)]) {
                                                                 [[self delegate] captureManagerStillImageCaptured:self];
                                                             }
                                                         }];
}

// Toggle between the front and back camera, if both are present.
- (BOOL) toggleCamera
{
    BOOL success = NO;
    
    if ([self cameraCount] > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[videoInput device] position];
        
        if (position == AVCaptureDevicePositionBack)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontFacingCamera] error:&error];
        else if (position == AVCaptureDevicePositionFront)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:&error];
        else
            goto bail;
        
        if (newVideoInput != nil) {
            [[self session] beginConfiguration];
            [[self session] removeInput:[self videoInput]];
            if ([[self session] canAddInput:newVideoInput]) {
                [[self session] addInput:newVideoInput];
                [self setVideoInput:newVideoInput];
            } else {
                [[self session] addInput:[self videoInput]];
            }
            [[self session] commitConfiguration];
            success = YES;
            [newVideoInput release];
        } else if (error) {
            if ([[self delegate] respondsToSelector:@selector(captureManager:didFailWithError:)]) {
                [[self delegate] captureManager:self didFailWithError:error];
            }
        }
    }
    
bail:
    return success;
}


#pragma mark Device Counts
- (NSUInteger) cameraCount
{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

- (NSUInteger) micCount
{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] count];
}


#pragma mark Camera Properties
// Perform an auto focus at the specified point. The focus mode will automatically change to locked once the auto focus is complete.
- (void) autoFocusAtPoint:(CGPoint)point
{
    AVCaptureDevice *device = [[self videoInput] device];
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            [device setFocusPointOfInterest:point];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            [device unlockForConfiguration];
        } else {
            if ([[self delegate] respondsToSelector:@selector(captureManager:didFailWithError:)]) {
                [[self delegate] captureManager:self didFailWithError:error];
            }
        }        
    }
}

// Switch to continuous auto focus mode at the specified point
- (void) continuousFocusAtPoint:(CGPoint)point
{
    AVCaptureDevice *device = [[self videoInput] device];
    
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            [device setFocusPointOfInterest:point];
            [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [device unlockForConfiguration];
        } else {
            if ([[self delegate] respondsToSelector:@selector(captureManager:didFailWithError:)]) {
                [[self delegate] captureManager:self didFailWithError:error];
            }
        }
    }
}

@end

@implementation AVCamCaptureManager (InternalUtilityMethods)

// Keep track of current device orientation so it can be applied to movie recordings and still image captures
- (void)deviceOrientationDidChange
{
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    if (deviceOrientation == UIDeviceOrientationPortrait)
        orientation = AVCaptureVideoOrientationPortrait;
    else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown)
        orientation = AVCaptureVideoOrientationPortraitUpsideDown;
    
    // AVCapture and UIDevice have opposite meanings for landscape left and right (AVCapture orientation is the same as UIInterfaceOrientation)
    else if (deviceOrientation == UIDeviceOrientationLandscapeLeft)
        orientation = AVCaptureVideoOrientationLandscapeRight;
    else if (deviceOrientation == UIDeviceOrientationLandscapeRight)
        orientation = AVCaptureVideoOrientationLandscapeLeft;
    
    // Ignore device orientations for which there is no corresponding still image orientation (e.g. UIDeviceOrientationFaceUp)
}

// Find a camera with the specificed AVCaptureDevicePosition, returning nil if one is not found
- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

// Find a front facing camera, returning nil if one is not found
- (AVCaptureDevice *) frontFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

// Find a back facing camera, returning nil if one is not found
- (AVCaptureDevice *) backFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

// Find and return an audio device, returning nil if one is not found
- (AVCaptureDevice *) audioDevice
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    if ([devices count] > 0) {
        return [devices objectAtIndex:0];
    }
    return nil;
}

- (NSURL *) tempFileURL
{
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"]];
}

- (void) removeFile:(NSURL *)fileURL
{
    NSString *filePath = [fileURL path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        if ([fileManager removeItemAtPath:filePath error:&error] == NO) {
            if ([[self delegate] respondsToSelector:@selector(captureManager:didFailWithError:)]) {
                [[self delegate] captureManager:self didFailWithError:error];
            }
        }
    }
}

- (void) copyFileToDocuments:(NSURL *)fileURL
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/output_%@.mov", [dateFormatter stringFromDate:[NSDate date]]];
    [dateFormatter release];
    NSError	*error;
    if (![[NSFileManager defaultManager] copyItemAtURL:fileURL toURL:[NSURL fileURLWithPath:destinationPath] error:&error]) {
        if ([[self delegate] respondsToSelector:@selector(captureManager:didFailWithError:)]) {
            [[self delegate] captureManager:self didFailWithError:error];
        }
    }
}	

@end
