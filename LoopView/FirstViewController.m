//
//  ViewController.m
//  LoopView
//
//  Created by 符现超 on 15/1/10.
//  Copyright (c) 2015年 当当. All rights reserved.
//

#import "FirstViewController.h"

#define kSCREEN_WIDTH	[[UIScreen mainScreen] bounds].size.width
#define kSCREEN_HEIGHT	[[UIScreen mainScreen] bounds].size.height
#define IMAGEVIEW_COUNT 3

@interface FirstViewController () <UIScrollViewDelegate>
{
	int _imageCount;
	int _currentImageIndex;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	_imageCount = 10;

	///实例化滚动视图和页码
	[self createScrollViewAndPageControl];

	///添加imageView和默认图片
	[self addImageViewAndLoadDefaultImage];
}

#pragma mark -

- (void)createScrollViewAndPageControl
{
	self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 49)];
	self.scrollView.backgroundColor = [UIColor redColor];
	self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH * IMAGEVIEW_COUNT, kSCREEN_HEIGHT - 49);
	self.scrollView.delegate = self;
	self.scrollView.pagingEnabled = YES;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	[self.view addSubview:self.scrollView];
	[self.scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH, 0) animated:NO];

	self.pageControl = [[UIPageControl alloc]init];
	CGSize size = [self.pageControl sizeForNumberOfPages:_imageCount];
	self.pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
	self.pageControl.center = CGPointMake(kSCREEN_WIDTH / 2.0f, kSCREEN_HEIGHT - 100);
	self.pageControl.pageIndicatorTintColor = [UIColor blueColor];
	self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
	self.pageControl.numberOfPages = _imageCount;
	[self.view addSubview:self.pageControl];
}

- (void)addImageViewAndLoadDefaultImage
{
	self.leftImageView = [[UIImageView alloc]init];
	self.centerImageView = [[UIImageView alloc]init];
	self.rightImageView = [[UIImageView alloc]init];

	NSArray *imageViews = @[self.leftImageView, self.centerImageView, self.rightImageView];

	for (NSInteger i = 0; i < imageViews.count; i++) {
		UIImageView *imageView = imageViews[i];
		imageView.frame = CGRectMake(kSCREEN_WIDTH * i, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);

		if (i == 0) {
			imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", _imageCount - 1]];
		}
		else {
			imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", i - 1]];
		}
		[self.scrollView addSubview:imageView];
	}

	_currentImageIndex = 0;
	//设置当前页
	self.pageControl.currentPage = _currentImageIndex;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self reloadImage];
	[self.scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH, 0) animated:NO];
	self.pageControl.currentPage = _currentImageIndex;
	//NSLog(@"\n页码：%d",_currentImageIndex);
}

- (void)reloadImage
{
	CGPoint offset = self.scrollView.contentOffset;

	///默认情况下的偏移量就是kSCREEN_WIDTH
	if (offset.x > kSCREEN_WIDTH) { //左滑动
		_currentImageIndex = (_currentImageIndex + 1) % _imageCount;
	}
	else if (offset.x < kSCREEN_WIDTH) { //右滑动
		//此处是为了避免一开始就右滑出现负数的情况，所以+_imageCount
		_currentImageIndex = (_currentImageIndex - 1 + _imageCount) % _imageCount;
	}

	self.centerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", _currentImageIndex]];
	self.leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", (_currentImageIndex - 1 + _imageCount) % _imageCount]];
	self.rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", (_currentImageIndex + 1) % _imageCount]];
}

//- (void)addImage
//{
//    NSString *imagePath  =  [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",1] ofType:@"jpg"];
//    NSData *imageData  =  [NSData dataWithContentsOfFile:imagePath];
//    UIImage *image  =  [UIImage imageWithData:imageData];
//}

#pragma mark -
- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
