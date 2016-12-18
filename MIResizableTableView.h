//
//  MIResizableTableView.h
//  MIResizableTableViewDemo
//
//  Created by Mario on 17/01/16.
//  Copyright © 2016 Mario. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MIResizableTableViewSectionHeader.h"

@class MIResizableTableView;

@protocol MIResizableTableViewDataSource <NSObject>

- (NSInteger)numberOfSectionsInResizableTableView:(MIResizableTableView *)resizableTableView;
- (NSInteger)resizableTableView:(MIResizableTableView *)resizableTableView numberOfRowsInSection:(NSInteger)section;

- (UIView *)resizableTableView:(MIResizableTableView *)resizableTableView viewForHeaderInSection:(NSInteger)section;
- (UITableViewCell *)resizableTableView:(MIResizableTableView *)resizableTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol MIResizableTableViewDelegate <NSObject>

- (CGFloat)resizableTableView:(MIResizableTableView *)resizableTableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)resizableTableView:(MIResizableTableView *)resizableTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewRowAnimation)resizableTableViewInsertRowAnimation;
- (UITableViewRowAnimation)resizableTableViewDeleteRowAnimation;

- (BOOL)resizableTableViewSectionShouldExpandSection:(NSInteger)section;

- (void)resizableTableView:(MIResizableTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MIResizableTableView : UITableView

- (void)configureWithDelegate:(id<MIResizableTableViewDelegate>)delegate andDataSource:(id<MIResizableTableViewDataSource>)dataSource;

@end
