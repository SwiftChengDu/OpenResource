//
//  DMRCTTable.h
//  RCTNative
//
//  Created by 杨涵 on 16/7/6.
//  Copyright © 2016年 yanghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>

@interface DMRCTTable : UITableView

@property (nonatomic, assign)   NSInteger                      selectIndex;
@property (nonatomic, copy)     RCTBubblingEventBlock          clickAtIndex;

@end
