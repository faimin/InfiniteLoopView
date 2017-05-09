//
//  myCollectionViewCell.m
//  LoopView
//
//  Created by 符现超 on 15/11/17.
//  Copyright © 2015年 当当. All rights reserved.
//

#import "MyCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewOfCell;

@end

@implementation MyCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
	// Initialization code
}

- (void)setImage:(UIImage *)image
{
	self.imageViewOfCell.image = image;
}

- (void)setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholder
{
    [self.imageViewOfCell sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholder ? : [UIImage imageNamed:@"0.jpg"]];
}

- (void)prepareForReuse
{
	self.imageViewOfCell.image = nil;
}

@end
