//
//  MyOtherClass.h
//  RunTimeDemo
//
//  Created by 杨涵 on 15/9/23.
//  Copyright © 2015年 yanghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOtherClass : NSObject

@property (nonatomic, copy)  NSString   *name;
@property (nonatomic, copy)  NSString   *status;

- (void)setDataWithDic:(NSDictionary *)dic;

@end
