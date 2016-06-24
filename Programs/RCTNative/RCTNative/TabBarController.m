//
//  TabBarController.m
//  RCTNative
//
//  Created by 杨涵 on 16/6/24.
//  Copyright © 2016年 yanghan. All rights reserved.
//

#import "TabBarController.h"
#import "TabBar.h"

@interface TabBarController () <TabBarDelegate>

@property (nonatomic, weak) IBOutlet TabBar      *aTabBar;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.aTabBar.adelegate = self;
}

- (void)tabBar:(TabBar *)tabBar didClickButton:(NSInteger)index {
    self.selectedIndex = index;
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
