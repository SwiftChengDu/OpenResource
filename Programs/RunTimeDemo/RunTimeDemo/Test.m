//
//  Test.m
//  RunTimeDemo
//
//  Created by 杨涵 on 15/9/10.
//  Copyright (c) 2015年 yanghan. All rights reserved.
//

#import "Test.h"
#import "MyClass.h"
#import <objc/runtime.h>
#import <Availability.h>

@implementation Test

- (void)ex_registerClassPair {
    SEL testMetaClass = NSSelectorFromString(@"testMetaClass");
    
    Class newClass = objc_allocateClassPair([NSError class], "TestClass", 0);
    class_addMethod(newClass, testMetaClass, (IMP)TestMetaClass, "v@:");
    objc_registerClassPair(newClass);
    
    id instance = [[newClass alloc] initWithDomain:@"some domain" code:0 userInfo:nil];
    [instance performSelector:testMetaClass];
    
    NSLog(@"实例变量大小 %zu",class_getInstanceSize([NSError class]));
}


void TestMetaClass(id self, SEL _cmd) {
    
    NSLog(@"This object is %p",self);
    NSLog(@"Class is %@, super class is %@",[self class],[self superclass]);
    
    Class currentClass = [self class];
    for (int i=0; i<4; i++) {
        NSLog(@"Following the isa pointer %d times gives %p",i,currentClass);
        
        currentClass = objc_getClass((__bridge void *)currentClass);
        
    }
    
    NSLog(@"NSObject's class is %p",[NSObject class]);
    NSLog(@"NSObject's meta class is %p",objc_getClass((__bridge void *)[NSObject class]));
}

- (void)testNSString {
    
}

- (void)registerNewClass {
    Class cls = objc_allocateClassPair(MyClass.class, "mySubClass", 0);
    class_addMethod(cls, @selector(submethod1), (IMP)imp_submethod1, "v@:");
    class_replaceMethod(cls, @selector(method1), (IMP)imp_submethod1, "v@:");
    class_addIvar(cls, "_ivar1", sizeof(NSString *), log(sizeof(NSString *)), "i");

    objc_property_attribute_t type =  {"T","@\"NSString\""};
    objc_property_attribute_t ownership = {"C",""};
    objc_property_attribute_t backingivar = {"V","_ivar1"};
    objc_property_attribute_t attrs[] = {type, ownership, backingivar};
    
    class_addProperty(cls, "property2", attrs, 3);
    objc_registerClassPair(cls);
    
    id instance = [[cls alloc] init];
    [instance performSelector:@selector(submethod1)];
    [instance performSelector:@selector(method1)];
}

void imp_submethod1(id self, SEL _cmd) {
    NSLog(@"run sub method 1");
}

- (void)testMyClass {
    
    MyClass *myClass = [[MyClass alloc] init];
    unsigned int outCount = 0;
    
    Class cls = myClass.class;
    
    NSLog(@"class name: %s",class_getName(cls));
    NSLog(@"=======================================");
    
    NSLog(@"super class name:%s",class_getName(class_getSuperclass(cls)));
    NSLog(@"=======================================");
    
    NSLog(@"MyClass is %@ a meta-class",(class_isMetaClass(cls)) ? @"":@"not");
    NSLog(@"=======================================");
    
    Class meta_class = objc_getMetaClass(class_getName(cls));
    NSLog(@"%s's meta-class is %s",class_getName(cls),class_getName(meta_class));
    NSLog(@"=======================================");
    
    NSLog(@"instance size:%zu",class_getInstanceSize(cls));
    NSLog(@"=======================================");
    
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i=0; i<outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"instance variable's name:%s at index:%d",ivar_getName(ivar),i);
    }
    
    free(ivars);
    
    Ivar string = class_getInstanceVariable(cls, "_string");
    if (string != NULL) {
        NSLog(@"instance variable %s",ivar_getName(string));
    }
    
    NSLog(@"=======================================");
    
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (int i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property's name :%s",property_getName(property));
    }
    
    free(properties);
    
    objc_property_t array = class_getProperty(cls, "array");
    if (array != NULL) {
        NSLog(@"property %s",property_getName(array));
    }
    
    NSLog(@"=======================================");
    
    Method *methods = class_copyMethodList(cls, &outCount);
    for (int i=0; i<outCount; i++) {
        Method method = methods[i];
        NSLog(@"method's signature: %s",sel_getName(method_getName(method)));
    }
    
    free(methods);
    
    Method method1 = class_getInstanceMethod(cls, @selector(method1));
    if (method1 != NULL) {
        NSLog(@"method %s",sel_getName(method_getName(method1)));
    }
    
    Method classMethod = class_getClassMethod(cls, @selector(classMethod1));
    if (classMethod != NULL) {
        NSLog(@"class method : %s",sel_getName(method_getName(classMethod)));
    }
    
    NSLog(@"MyClass is %@ responsd to selector: method3WithArg1:arg2:",class_respondsToSelector(cls, @selector(method3WithArg1:arg2:)) ? @"":@"not");
    
    IMP imp = class_getMethodImplementation(cls, @selector(method1));
    imp();
    
    NSLog(@"=======================================");
    
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList(cls, &outCount);
    Protocol *protocol;
    for (int i=0; i<outCount; i++) {
        protocol = protocols[i];
        NSLog(@"protocol name: %s",protocol_getName(protocol));
    }
    
    NSLog(@"MyClass is %@ responsed to protocol %s",class_conformsToProtocol(cls, protocol)?@"":@"not",protocol_getName(protocol));
    NSLog(@"=======================================");
}
@end