//
//  CategoryView.m
//  MIResizableTableViewDemo
//
//  Created by Mario on 17/01/16.
//  Copyright © 2016 Mario. All rights reserved.
//

#import "CategoryView.h"

@interface CategoryView()

@property (nonatomic, weak) IBOutlet UILabel *categoryTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *productsNumberLabel;

@end

@implementation CategoryView

+ (CategoryView *)getViewWithTitle:(NSString *)title andProductsNumber:(NSInteger)productsNumber {
    
    CategoryView *view = [[[NSBundle mainBundle] loadNibNamed:@"CategoryView" owner:self options:nil] objectAtIndex:0];
    [view configureWithTitle:title andProductsNumber:productsNumber];
    
    return view;
}

- (void)configureWithTitle:(NSString *)title andProductsNumber:(NSInteger)productsNumber {
    
    self.categoryTitleLabel.text = title;
    self.productsNumberLabel.text = [NSString stringWithFormat:@"%zd items", productsNumber];
}

@end
