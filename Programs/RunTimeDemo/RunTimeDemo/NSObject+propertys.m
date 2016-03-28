//
//  NSObject+propertys.m
//  RunTimeDemo
//
//  Created by 杨涵 on 15/10/21.
//  Copyright © 2015年 yanghan. All rights reserved.
//

#import "NSObject+propertys.h"

@implementation NSObject (propertys)

- (NSDictionary *)propertys_aps {
    unsigned int outCount,i;
    objc_property_t *propertys = class_copyPropertyList([self class], &outCount);
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    
    for (i=0; i<outCount; i++) {
        objc_property_t property = propertys[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue) {
            [props setObject:propertyValue forKey:propertyName];
        }else{
            [props setObject:@"" forKey:propertyName];
        }
    }
    free(propertys);
    return props;
}
@end
