//
//  MIResizableTableView.m
//  MIResizableTableViewDemo
//
//  Created by Mario on 17/01/16.
//  Copyright © 2016 Mario. All rights reserved.
//

#import "MIResizableTableView.h"

@interface MIResizableTableView() <UITableViewDelegate, UITableViewDataSource, MIResizableTableViewSectionHeaderDelegate>

@property (nonatomic, strong) NSMutableArray *contractedSections;

@property (weak, nonatomic) id<MIResizableTableViewDataSource> resizableTableViewDataSource;
@property (weak, nonatomic) id<MIResizableTableViewDelegate> resizableTableViewDelegate;

@end

@implementation MIResizableTableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initialSetup];
        
    }
    
    return self;
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initialSetup];
        
    }
    
    return self;
    
}

- (void)initialSetup {
    
    self.delegate = self;
    self.dataSource = self;
    
    self.contractedSections = [NSMutableArray new];
    
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Public
- (void)configureWithDelegate:(id<MIResizableTableViewDelegate>)delegate andDataSource:(id<MIResizableTableViewDataSource>)dataSource {
    
    self.resizableTableViewDelegate = delegate;
    self.resizableTableViewDataSource = dataSource;
    
    [self reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self numberOfSectionsForResizableTableView:(MIResizableTableView *)tableView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self isSectionContracted:section])
        return  0;
    else
        return [self numberOfRowsInSection:section forResizableTableView:(MIResizableTableView *)tableView];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MIResizableTableViewSectionHeader *headerSection = [MIResizableTableViewSectionHeader getView];
    
    [headerSection setupWithDelegate:self andSection:section];
    
    if (self.resizableTableViewDataSource && [self.resizableTableViewDataSource respondsToSelector:@selector(resizableTableView:viewForHeaderInSection:)]) {
        
        UIView *contentView = [self.resizableTableViewDataSource resizableTableView:self viewForHeaderInSection:section];
        [headerSection configureWithContentView:contentView];
        
    }
    
    [headerSection setupWithDelegate:self andSection:section];
    
    return headerSection;
    
}
- (UITableViewCell *)tableView:(MIResizableTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (self.resizableTableViewDelegate && [self.resizableTableViewDelegate respondsToSelector:@selector(resizableTableView:cellForRowAtIndexPath:)]) {
        
        cell = [self.resizableTableViewDataSource resizableTableView:self cellForRowAtIndexPath:indexPath];
        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return [self.resizableTableViewDelegate resizableTableView:self heightForHeaderInSection:section]; }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return [self.resizableTableViewDelegate resizableTableView:self heightForRowAtIndexPath:indexPath]; }
- (BOOL)resizableTableViewHeaderSectionShouldExpand:(NSInteger)section {
    
    BOOL shouldExpandSection = YES;
    
    if (self.resizableTableViewDelegate && [self.resizableTableViewDelegate respondsToSelector:@selector(resizableTableViewSectionShouldExpandSection:)]) {
        shouldExpandSection = [self.resizableTableViewDelegate resizableTableViewSectionShouldExpandSection:section];
    }
    
    return shouldExpandSection;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.resizableTableViewDelegate && [self.resizableTableViewDelegate respondsToSelector:@selector(resizableTableView:didSelectRowAtIndexPath:)]) {
        
        [self.resizableTableViewDelegate resizableTableView:self didSelectRowAtIndexPath:indexPath];
        
    }
}

#pragma mark - ResizableTableViewSectionHeaderDelegate
- (void)expand:(BOOL)expand rowsInSection:(NSInteger)section {
    
    if (expand) {
        
        [self.contractedSections removeObject:[NSNumber numberWithInteger:section]];
        
        NSMutableArray *indexPaths = [NSMutableArray new];
        
        for (int i = 0; i < [self.resizableTableViewDataSource resizableTableView:self numberOfRowsInSection:section]; i++)
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        
        [self insertRowsAtIndexPaths:indexPaths withRowAnimation:[self insertRowAnimation]];
        
    } else if (![self isSectionContracted:section]) {
        
        [self.contractedSections addObject:[NSNumber numberWithInteger:section]];
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [self.resizableTableViewDataSource resizableTableView:self numberOfRowsInSection:section]; i++)
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        
        [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:[self deleteRowAnimation]];
        
    }
    
}

#pragma mark - Private and Shortcut
- (NSInteger)numberOfSectionsForResizableTableView:(MIResizableTableView *)tableView {
    
    NSInteger numberOfSections = 0;
    
    if (self.resizableTableViewDataSource && [self.resizableTableViewDataSource respondsToSelector:@selector(numberOfSectionsInResizableTableView:)]) {
        return [self.resizableTableViewDataSource numberOfSectionsInResizableTableView:(MIResizableTableView *)tableView];
    }
    
    return numberOfSections;
    
}
- (NSInteger)numberOfRowsInSection:(NSInteger)section forResizableTableView:(MIResizableTableView *)tableView {
    
    NSInteger numberOfRows = 0;
    
    if (self.resizableTableViewDataSource && [self.resizableTableViewDataSource respondsToSelector:@selector(resizableTableView:numberOfRowsInSection:)]) {
        numberOfRows = [self.resizableTableViewDataSource resizableTableView:tableView numberOfRowsInSection:section];
    }
    
    return numberOfRows;
    
}

- (UITableViewRowAnimation)insertRowAnimation {
    
    UITableViewRowAnimation rowAnimation = UITableViewRowAnimationFade;
    
    if (self.resizableTableViewDelegate && [self.resizableTableViewDelegate respondsToSelector:@selector(resizableTableViewInsertRowAnimation)]) {
        rowAnimation = [self.resizableTableViewDelegate resizableTableViewInsertRowAnimation];
    }
    
    return rowAnimation;
    
}
- (UITableViewRowAnimation)deleteRowAnimation {
    
    UITableViewRowAnimation rowAnimation = UITableViewRowAnimationFade;
    
    if (self.resizableTableViewDelegate && [self.resizableTableViewDelegate respondsToSelector:@selector(resizableTableViewDeleteRowAnimation)]) {
        rowAnimation = [self.resizableTableViewDelegate resizableTableViewDeleteRowAnimation];
    }
    
    return rowAnimation;
    
}

- (BOOL)isSectionContracted:(NSInteger)section {
    
    return [self.contractedSections containsObject:[NSNumber numberWithInteger:section]];
}

@end