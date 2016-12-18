//
//  CategoryView.h
//  MIResizableTableViewDemo
//
//  Created by Mario on 17/01/16.
//  Copyright © 2016 Mario. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryView : UIView

+ (CategoryView *)getViewWithTitle:(NSString *)title andProductsNumber:(NSInteger)productsNumber;

@end
