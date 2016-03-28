//
//  MyClass.h
//  RunTimeDemo
//
//  Created by 杨涵 on 15/9/11.
//  Copyright (c) 2015年 yanghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyClass : NSObject <NSCopying, NSCoding>

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, copy)   NSString *string;

- (void)method1;
- (void)method2;
- (void)classMethod1;

@end
