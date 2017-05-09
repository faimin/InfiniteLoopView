//
//  ImageCollectionViewCell.m
//  MMUIDemo
//
//  Created by MOMO on 2017/5/5.
//  Copyright © 2017年 MOMO. All rights reserved.
//

#import "ZDImageCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ZDImageCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ZDImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.imageView];
}

#pragma mark - Property

- (void)setImageData:(id)imageData {
    if (!imageData) return;
    
    if ([imageData isKindOfClass:[UIImage class]]) {
        self.imageView.image = imageData;
    }
    else if ([imageData isKindOfClass:[NSString class]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageData]];
    }
    else if ([imageData isKindOfClass:[NSURL class]]) {
        [self.imageView sd_setImageWithURL:imageData];
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            imageView.backgroundColor = [UIColor yellowColor];
            //imageView.clipsToBounds = YES;
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            imageView;
        });
    }
    return _imageView;
}

@end
