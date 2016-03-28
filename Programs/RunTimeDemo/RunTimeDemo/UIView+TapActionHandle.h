//
//  UIView+TapActionHandle.h
//  RunTimeDemo
//
//  Created by 杨涵 on 15/9/22.
//  Copyright © 2015年 yanghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TapActionHandle)

- (void)setTapActionWithBlock:(void (^)(void))block;

@end
