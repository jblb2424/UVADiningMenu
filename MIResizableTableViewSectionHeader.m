//
//  MIResizableTableViewSectionHeader.m
//  MIResizableTableViewDemo
//
//  Created by Mario on 17/01/16.
//  Copyright © 2016 Mario. All rights reserved.
//

#import "MIResizableTableViewSectionHeader.h"

@interface MIResizableTableViewSectionHeader()

@property (nonatomic, weak) IBOutlet UIView *resizableTableViewSectionHeaderContentView;

@property (nonatomic, weak) id<MIResizableTableViewSectionHeaderDelegate> resizableTableViewSectionHeaderDelegate;

@property (nonatomic, assign) BOOL isExpanded;

@end

@implementation MIResizableTableViewSectionHeader

+ (MIResizableTableViewSectionHeader *)getView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"MIResizableTableViewSectionHeader" owner:self options:nil] objectAtIndex:0];
}


- (void)setupWithDelegate:(id<MIResizableTableViewSectionHeaderDelegate>)delegate andSection:(NSInteger)section {
    
    self.resizableTableViewSectionHeaderDelegate = delegate;
    self.resizableTableViewSectionHeaderContentView.tag = section;
}
- (void)configureWithContentView:(UIView *)contentView {
    
    [self.resizableTableViewSectionHeaderContentView addSubview:contentView];
    
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.resizableTableViewSectionHeaderContentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.resizableTableViewSectionHeaderContentView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.resizableTableViewSectionHeaderContentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.resizableTableViewSectionHeaderContentView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.resizableTableViewSectionHeaderContentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.resizableTableViewSectionHeaderContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.resizableTableViewSectionHeaderContentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.resizableTableViewSectionHeaderContentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
}

#pragma mark - IBActions
- (IBAction)expandContract:(id)sender {
    
    self.isExpanded = !self.isExpanded;
    
    if (self.resizableTableViewSectionHeaderDelegate && [self.resizableTableViewSectionHeaderDelegate respondsToSelector:@selector(expand:rowsInSection:)] && [self shouldExpandSection:self.resizableTableViewSectionHeaderContentView.tag]) {
        [self.resizableTableViewSectionHeaderDelegate expand:!self.isExpanded rowsInSection:self.resizableTableViewSectionHeaderContentView.tag];
    }
    
}

#pragma mark - Shortcut
- (BOOL)shouldExpandSection:(NSInteger)section {
    
    BOOL shouldExpandSection = YES;
    
    if (self.resizableTableViewSectionHeaderDelegate && [self.resizableTableViewSectionHeaderDelegate respondsToSelector:@selector(resizableTableViewHeaderSectionShouldExpand:)]) {
        shouldExpandSection = [self.resizableTableViewSectionHeaderDelegate resizableTableViewHeaderSectionShouldExpand:section];
    }
    
    return shouldExpandSection;
}

@end
