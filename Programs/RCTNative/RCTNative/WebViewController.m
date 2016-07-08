//
//  WebViewController.m
//  RCTNative
//
//  Created by 杨涵 on 16/6/30.
//  Copyright © 2016年 yanghan. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    UINavigationItem *item = [[UINavigationItem alloc] init];
    item.title = @"详情";
    [bar pushNavigationItem:item animated:YES];
    [self.view addSubview:bar];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(back)];
    [item setLeftBarButtonItem:barButton];
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    web.scalesPageToFit = YES;
    [self.view addSubview:web];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
