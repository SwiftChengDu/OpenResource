//
//  MyOtherClass.m
//  RunTimeDemo
//
//  Created by 杨涵 on 15/9/23.
//  Copyright © 2015年 yanghan. All rights reserved.
//

#import "MyOtherClass.h"
#import <objc/runtime.h>
#import "NSObject+propertys.h"

static NSMutableDictionary *map = nil;

@implementation MyOtherClass

+ (void)load {
    map = [NSMutableDictionary dictionary];
    
    map[@"name1"] = @"name";
    map[@"status1"] = @"status";
    map[@"name2"] = @"name";
    map[@"status2"] = @"status";
}

- (NSString *)propertyForKey:(NSString *)key {
    
    return map[key];
}

- (BOOL)equalPropertyName:(NSString *)name {
    NSDictionary *pros = [self propertys_aps];
    return [[pros allKeys] containsObject:name];
}

- (void)setDataWithDic:(NSDictionary *)dic {
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *propertyKey = [self propertyForKey:key];
        if (propertyKey) {
            objc_property_t property = class_getProperty([self class], [propertyKey UTF8String]);
            
            NSString *attributeString = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        }
        if([self equalPropertyName:propertyKey]) {
            [self setValue:obj forKey:propertyKey];
        }
    }];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([value isKindOfClass:[NSString class]]) {
        objc_setAssociatedObject(self, (__bridge const void *)(key), value, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }else {
        objc_setAssociatedObject(self, (__bridge const void *)(key), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (id)valueForUndefinedKey:(NSString *)key {
    
    return objc_getAssociatedObject(self, (__bridge const void *)(key));
}

@end
