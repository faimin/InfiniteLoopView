//
//  myCollectionViewCell.h
//  LoopView
//
//  Created by 符现超 on 15/11/17.
//  Copyright © 2015年 当当. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewCell : UICollectionViewCell

- (void)setImage:(UIImage *)image;

- (void)setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholder;

@end
