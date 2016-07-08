//
//  ViewController2.m
//  RCTNative
//
//  Created by 杨涵 on 16/6/27.
//  Copyright © 2016年 yanghan. All rights reserved.
//

#import "ViewController2.h"
#import "MessageCenter.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Personal";
}

- (IBAction)messageAction:(id)sender {
    MessageCenter *mc = [[MessageCenter alloc] init];
    [self.navigationController pushViewController:mc animated:YES];
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
