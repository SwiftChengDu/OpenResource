//
//  RCTTableManager.m
//  RCTNative
//
//  Created by 杨涵 on 16/7/6.
//  Copyright © 2016年 yanghan. All rights reserved.
//

#import "DMRCTTableManager.h"
#import "DMRCTTable.h"
#import <UIKit/UIKit.h>

@interface DMRCTTableManager() <UITableViewDelegate,UITableViewDataSource>

@end

@implementation DMRCTTableManager

RCT_EXPORT_MODULE()
RCT_EXPORT_VIEW_PROPERTY(rowHeight, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(selectIndex, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(clickAtIndex, RCTBubblingEventBlock)


- (UIView *)view {
    DMRCTTable *table = [[DMRCTTable alloc] init];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    return table;
}

#pragma mark - tableViewDelegate/Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"#%d",indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(DMRCTTable *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!tableView.clickAtIndex) {
        return;
    }
    
    tableView.clickAtIndex(@{
        @"selectIndex":@(indexPath.row)
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return tableView.rowHeight;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

@end
