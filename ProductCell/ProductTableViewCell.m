//
//  CustomTableViewCell.m
//  MIResizableTableViewDemo
//
//  Created by Mario on 17/01/16.
//  Copyright © 2016 Mario. All rights reserved.
//

#import "ProductTableViewCell.h"

@interface ProductTableViewCell()

@property (nonatomic, weak) IBOutlet UILabel *productTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *productDescriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *productPriceLabel;


@end

@implementation ProductTableViewCell

+ (UINib *)cellNib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}
+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithProductTitle:(NSString *)title description:(NSString *)description andPrice:(NSString *)price {
    
    self.productTitleLabel.text = title;
    self.productDescriptionLabel.text = description;
    self.productPriceLabel.text = price;
    
    self.productDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.productDescriptionLabel.numberOfLines = 0;
}

@end
