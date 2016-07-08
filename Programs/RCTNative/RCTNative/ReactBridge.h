//
//  ReactBridge.h
//  RCTNative
//
//  Created by 杨涵 on 16/7/6.
//  Copyright © 2016年 yanghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>

@protocol ReactBridgeDelegate <NSObject>

+ (NSString *)bridgeName;

@end

@interface ReactBridge : NSObject <RCTBridgeModule, ReactBridgeDelegate>

@property (nonatomic, strong)    UIViewController       *viewController;

@end
