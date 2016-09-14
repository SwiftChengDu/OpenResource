//
//  MessageCenter.m
//  RCTNative
//
//  Created by 杨涵 on 16/6/27.
//  Copyright © 2016年 yanghan. All rights reserved.
//

#import "MessageCenter.h"
#import <React/RCTRootView.h>
#import "WebViewController.h"

@interface MessageCenter ()

@end

@implementation MessageCenter

RCT_EXPORT_MODULE();

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    
    NSURL *jsCodeLocation;
//    jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle?platform=ios"];
    jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation moduleName:@"SimpleApp" initialProperties:nil launchOptions:nil];
    [self.view addSubview:rootView];
    
    rootView.frame = self.view.bounds;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:@"backNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoUrlVC:) name:@"goToWebNotification" object:nil];
}

RCT_EXPORT_METHOD(jumpBack)
{
    //界面回退
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backNotification" object:nil];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoUrlVC:(NSNotification *)notification {
    WebViewController *webvc = [[WebViewController alloc] init];
    webvc.urlString = notification.object;
    [self.navigationController pushViewController:webvc animated:YES];
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(jumpToUrl:(NSString *)urlString param:(NSDictionary *)params)
{
    //界面跳转
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToWebNotification" object:urlString userInfo:params];
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
