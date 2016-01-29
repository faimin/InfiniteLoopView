//
//  SecondViewController.m
//  LoopView
//
//  Created by 符现超 on 15/1/11.
//  Copyright (c) 2015年 当当. All rights reserved.
//

#import "SecondViewController.h"
#import "MyImageView.h"

//#define getImageFromFileName(fileName) [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"]
#define SCREEN_WIDTH		[UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT		[UIScreen mainScreen].bounds.size.height
#define PAGE_CONTROL_HEIGHT 20
#define IMAGE_COUNT			10

@interface SecondViewController () <UIScrollViewDelegate>
{
	UIScrollView *myScrollView;

	UIPageControl *pageControl;

	int lastPage;
}

@property (nonatomic, strong) NSMutableDictionary *visiblePages;

@property (nonatomic, strong) NSMutableSet *recyledPages;

@property (nonatomic, strong) NSMutableArray *imageArray;

@end

/**
 *  大致思路：
 *  一开始可见视图visibleImageView只加载2页(第1页和第2页),所以刚开始时程序禁止向后滑动。开始向前滑动后,它会加载当前页的前一页image,并且先向重用池中通过对应的key(此处为页码作为key)去取imageView,如果没有的话会创建一个imageView，并加入到visibleImageView中,而且把当前页码的倒数第2页添加到到重用池,并从可见视图和父视图中移除,这样就保证了一共只有3个imageView视图;向后滑动是一样的原理.
 */

@implementation SecondViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.imageArray = [[NSMutableArray alloc] init];

	for (int i = 0; i < IMAGE_COUNT; i++) {
		NSString *fileName = [NSString stringWithFormat:@"%i.jpg", i];
		UIImage *image = [UIImage imageNamed:fileName];

		if (nil != image) {
			[self.imageArray addObject:image];
		}
		else {
			NSLog(@"image is nil");
		}
	}

	myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
	myScrollView.contentSize = CGSizeMake(INT32_MAX, SCREEN_HEIGHT - 49);
	myScrollView.delegate = self;
	myScrollView.bounces = YES;
	myScrollView.pagingEnabled = YES;
	myScrollView.userInteractionEnabled = YES;
	[self.view addSubview:myScrollView];

	self.visiblePages = [[NSMutableDictionary alloc] init];
	self.recyledPages = [[NSMutableSet alloc] init];

	pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - PAGE_CONTROL_HEIGHT - 80, SCREEN_WIDTH, PAGE_CONTROL_HEIGHT)];
	pageControl.numberOfPages = IMAGE_COUNT;
	pageControl.currentPage = 0;
	pageControl.currentPageIndicatorTintColor = [UIColor redColor];
	pageControl.pageIndicatorTintColor = [UIColor purpleColor];
	[self.view addSubview:pageControl];

	lastPage = 0; //上一页

	[self tilesPage];
}

- (void)tilesPage
{
	int currentPage = floor(myScrollView.contentOffset.x / SCREEN_WIDTH);

	NSLog(@"\n当前页：%d", currentPage);

	if (currentPage == 0 && lastPage == 0) { //刚开始的时候
		MyImageView *firstImageView = [[MyImageView alloc] initWithImage:[self.imageArray objectAtIndex:0]];
		firstImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
		[myScrollView addSubview:firstImageView];
		[self.visiblePages setValue:firstImageView forKey:[NSString stringWithFormat:@"%i.jpg", 0]];

		MyImageView *secondImageView = [[MyImageView alloc] initWithImage:[self.imageArray objectAtIndex:1]];
		secondImageView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
		[myScrollView addSubview:secondImageView];
		[self.visiblePages setValue:secondImageView forKey:[NSString stringWithFormat:@"%i.jpg", 1]];
	}
	else {
		if (currentPage == lastPage) { //没滑过去（没滑到其他页）的时候返回
			return;
		}

		if (currentPage > lastPage) {
			//forward
			if (currentPage * SCREEN_WIDTH < INT32_MAX) {
				UIImage *image = [self.imageArray objectAtIndex:(currentPage + 1) % IMAGE_COUNT];
				MyImageView *imageView = [self getRecyledImageView:image];

				if (!imageView) {
					imageView = [[MyImageView alloc] initWithImage:image];
				}
				imageView.frame = CGRectMake((currentPage + 1) * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
				[myScrollView addSubview:imageView];
				[self.visiblePages setValue:imageView forKey:[NSString stringWithFormat:@"%i.jpg", currentPage + 1]]; //添加到可见视图池中
			}

			NSString *key = [NSString stringWithFormat:@"%i.jpg", currentPage - 2];
			MyImageView *recyledImageView = [self.visiblePages objectForKey:key];

			if (recyledImageView) {
				[self.recyledPages addObject:recyledImageView]; //添加到重用池
				[recyledImageView removeFromSuperview];         //重用的这张imageView从父视图移除
				[self.visiblePages removeObjectForKey:key];     //并且还从可见区移除
			}
		}
		else {
			//backward
			if (currentPage > 0) { //只有当当前页的页码>0它才有前一页
				UIImage *image = [self.imageArray objectAtIndex:(currentPage - 1) % IMAGE_COUNT];
				MyImageView *imageView = [self getRecyledImageView:image];

				if (!imageView) {
					imageView = [[MyImageView alloc] initWithImage:image];
				}
				imageView.frame = CGRectMake((currentPage - 1) * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
				[myScrollView addSubview:imageView];
				[self.visiblePages setValue:imageView forKey:[NSString stringWithFormat:@"%i.jpg", currentPage - 1]];
			}

			NSString *key = [NSString stringWithFormat:@"%i.jpg", currentPage + 2];
			MyImageView *recyledImageView = [self.visiblePages objectForKey:key];

			if (recyledImageView) {
				[self.recyledPages addObject:recyledImageView];
				[recyledImageView removeFromSuperview];
				[self.visiblePages removeObjectForKey:key];
			}
		}
	}

	lastPage = currentPage;
	NSLog(@"\n可见页码数： %lu \n重用页码数： %lu", (unsigned long)self.visiblePages.count, (unsigned long)self.recyledPages.count);
	[pageControl setCurrentPage:currentPage % IMAGE_COUNT];
}

- (MyImageView *)getRecyledImageView:(UIImage *)image
{
	MyImageView *imageView = [self.recyledPages anyObject];
	if (imageView) {
		imageView.image = image;
		[self.recyledPages removeObject:imageView];
	}
	return imageView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self tilesPage];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"释放了");
}

/*
 * #pragma mark - Navigation
 *
 *  // In a storyboard-based application, you will often want to do a little preparation before navigation
 *  - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 *   // Get the new view controller using [segue destinationViewController].
 *   // Pass the selected object to the new view controller.
 *  }
 */

@end
