//
//  MIResizableTableViewSectionHeader.h
//  MIResizableTableViewDemo
//
//  Created by Mario on 17/01/16.
//  Copyright © 2016 Mario. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MIResizableTableViewSectionHeaderDelegate <NSObject>

- (void)expand:(BOOL)expand rowsInSection:(NSInteger)section;
- (BOOL)resizableTableViewHeaderSectionShouldExpand:(NSInteger)section;

@end

@interface MIResizableTableViewSectionHeader : UIView

+ (MIResizableTableViewSectionHeader *)getView;

- (void)setupWithDelegate:(id<MIResizableTableViewSectionHeaderDelegate>)delegate andSection:(NSInteger)section;
- (void)configureWithContentView:(UIView *)contentView;

@end
