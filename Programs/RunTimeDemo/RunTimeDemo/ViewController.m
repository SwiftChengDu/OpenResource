//
//  ViewController.m
//  RunTimeDemo
//
//  Created by 杨涵 on 15/9/10.
//  Copyright (c) 2015年 yanghan. All rights reserved.
//

#import "ViewController.h"
#import "Test.h"
#import "UIView+TapActionHandle.h"
#import "MyOtherClass.h"
#import "RunTimeDemo-Swift.h"
#import <objc/runtime.h>
#import "RuntimeCategoryClass.h"
#import "RuntimeCategoryClass+Category.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIWebView *myWeb;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Test *te = [[Test alloc] init];
    [te ex_registerClassPair];
    
    [te testMyClass];
    [te registerNewClass];
    
    float a[] = {1.0,2.0,3.0};
    NSLog(@"%s",@encode(typeof(a)));
    
    
    [self.view setTapActionWithBlock:^{
        NSLog(@"clik the view");
    }];
    
    NSDictionary *dic1 = @{@"name1":@"zhangsan",@"status1":@"start"};
    NSDictionary *dic2 = @{@"name2":@"lisi",@"status2":@"end"};
    MyOtherClass *other = [MyOtherClass new];
    [other setDataWithDic:dic1];
    NSLog(@"name:%@ status:%@",other.name,other.status);
    [other setDataWithDic:dic2];
    NSLog(@"name:%@ status:%@",other.name,other.status);
    
    NSString *emoj = @"多哈😂😂";
    NSString *answ = [emoj stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *ques = [answ stringByRemovingPercentEncoding];
    NSLog(@"em:%@--%@",answ,ques);
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"icon1" ofType:@"svg"];
//    NSData *imgeData = [[NSData alloc] initWithContentsOfFile:filePath];
//    NSURL *url = [[NSURL alloc] initFileURLWithPath:[NSBundle mainBundle].resourcePath isDirectory:YES];
//    [self.myWeb loadData:imgeData MIMEType:@"image/svg+xml" textEncodingName:@"UTF-8" baseURL:url];
    
    unsigned int outCount = 0;
    
    Method *methodList = class_copyMethodList([RuntimeCategoryClass class], &outCount);
    for (int i=0; i<outCount; i++) {
        Method method = methodList[i];
        
        const char *name = sel_getName(method_getName(method));
        NSLog(@"RuntimeCategoryClass's method:%s",name);
        if (strcmp(name, sel_getName(@selector(method2)))) {
            NSLog(@"分类方法method2在objc_class的方法列表中");
        }
    }
}


- (IBAction)vc1Action:(id)sender {
    VC1 *vc1 = [[VC1 alloc] init];
    [self presentViewController:vc1 animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
