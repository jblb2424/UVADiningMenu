//
//  CustomTableViewCell.h
//  MIResizableTableViewDemo
//
//  Created by Mario on 17/01/16.
//  Copyright © 2016 Mario. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTableViewCell : UITableViewCell

+ (UINib *)cellNib;
+ (NSString *)cellIdentifier;

- (void)configureWithProductTitle:(NSString *)title description:(NSString *)description andPrice:(NSString *)price;

@end
