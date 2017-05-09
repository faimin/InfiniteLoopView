//
//  MMScrollView.h
//  MMUIDemo
//
//  Created by MOMO on 2017/5/5.
//  Copyright © 2017年 MOMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDCycleScrollView : UIView

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSArray<UIImage *> *images;
@property (nonatomic, strong) NSArray<NSString *> *imageURLs;

@end
