//
//  UIView+TapActionHandle.m
//  RunTimeDemo
//
//  Created by 杨涵 on 15/9/22.
//  Copyright © 2015年 yanghan. All rights reserved.
//

#import "UIView+TapActionHandle.h"
#import <objc/runtime.h>

#define handleTapGestureKey "tapGestureKey"
#define handleTapBlockKey "tapBlockKey"

@implementation UIView (TapActionHandle)

- (void)setTapActionWithBlock:(void (^)(void))block {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &handleTapGestureKey);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &handleTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &handleTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        void (^action)(void) = objc_getAssociatedObject(self, &handleTapBlockKey);
        if (action) {
            action();
        }
    }
}

@end
