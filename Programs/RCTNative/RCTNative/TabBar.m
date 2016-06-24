//
//  TabBar.m
//  RCTNative
//
//  Created by 杨涵 on 16/6/24.
//  Copyright © 2016年 yanghan. All rights reserved.
//

#import "TabBar.h"

@interface TabBar()

@property (nonatomic, strong)   NSArray         *btnImages;
@property (nonatomic, strong)   NSMutableArray         *buttons;
@property (nonatomic, strong)   UIButton        *selButton;

@end

@implementation TabBar

- (NSArray *)btnImages {
    
    return @[@"tabbar_home.png",@"tabbar_message.png",@"tabbar_profile.png"];
}

- (NSMutableArray *)buttons {
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (NSInteger i=0; i<self.btnImages.count; i++) {
        NSString *imageName = self.btnImages[i];
        UIButton *button = [self buttonWithImageName:imageName];
        button.tag = i;
        if (i == 0) {
            [self buttonClick:button];
        }
        [self addSubview:button];
        [self.buttons addObject:button];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger count = self.buttons.count;
    double width = CGRectGetWidth(self.bounds) / count;
    double height = CGRectGetHeight(self.bounds);
    
    CGRect frame = CGRectMake(0, 0, width, height);
    for (UIButton *btn in self.buttons) {
        btn.frame = CGRectOffset(frame, btn.tag*width, 0);
    }
}

- (UIButton *)buttonWithImageName:(NSString *)imageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonClick:(UIButton *)sender {
    if (sender == self.selButton) {
        return;
    }
    
    self.selButton = sender;
    [self.adelegate tabBar:self didClickButton:sender.tag];
}
@end
