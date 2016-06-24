//
//  TabBar.h
//  RCTNative
//
//  Created by 杨涵 on 16/6/24.
//  Copyright © 2016年 yanghan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabBar;

@protocol TabBarDelegate<NSObject>

- (void)tabBar:(TabBar *)tabBar didClickButton:(NSInteger)index;

@end
    
@interface TabBar : UITabBar

@property (nonatomic, assign)  id<TabBarDelegate>       adelegate;

@end
