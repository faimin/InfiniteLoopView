//
//  ThirdViewController.m
//  LoopView
//
//  Created by 符现超 on 15/11/17.
//  Copyright © 2015年 当当. All rights reserved.
//  

/**
 * 思路:在源数据中数组前后分别添加了最后一张和第一张图,原理和前2种大同小异;
 * 
 * 优点就是利用了UICollectionView的复用机制,不用自己处理复用
 */

#import "ThirdViewController.h"
#import "MyCollectionViewCell.h"

#define kSCREEN_WIDTH	[[UIScreen mainScreen] bounds].size.width
#define kSCREEN_HEIGHT	[[UIScreen mainScreen] bounds].size.height
#define IMAGE_COUNT 10

@interface ThirdViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *imageData;

@end

@implementation ThirdViewController

#pragma mark - LifeCycel

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
    
	self.myCollectionView = ({
		UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
		flowLayout.minimumInteritemSpacing = 0;
		flowLayout.minimumLineSpacing = 0;
		flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		flowLayout.itemSize = (CGSize) {kSCREEN_WIDTH, kSCREEN_HEIGHT};

		UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:(CGRect) {0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT}collectionViewLayout:flowLayout];
		collectionView.showsHorizontalScrollIndicator = NO;
		collectionView.showsVerticalScrollIndicator = NO;
		collectionView.backgroundColor = [UIColor orangeColor];
		collectionView.pagingEnabled = YES;
		collectionView.delegate = self;
		collectionView.dataSource = self;
		[collectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MyCollectionViewCell class])];
        //MARK:显示第二张图片,因为在源数据中数组前后分别添加了最后一张和第一张,原理和前2种大同小异
        collectionView.contentOffset = CGPointMake(collectionView.bounds.size.width, 0);
        
		collectionView;
	});
    
    [self.view addSubview:self.myCollectionView];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDatasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
#if 0
	return self.dataArray.count;
#else 
    return self.imageData.count;
#endif
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MyCollectionViewCell class]) forIndexPath:indexPath];
#if 0
    [cell setImage:self.dataArray[indexPath.row]];
#else
    [cell setImageWithURL:self.imageData[indexPath.row] placeholderImage:nil];
#endif
	return cell;
}

//MARK:点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%ld个", indexPath.row);
}

// 停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat contentWidth = scrollView.contentSize.width;
    CGFloat boundsWidth = self.myCollectionView.bounds.size.width;
    if (offsetX >= (contentWidth - boundsWidth)) {
        scrollView.contentOffset = CGPointMake(boundsWidth, scrollView.contentOffset.y);
    }
    else if (offsetX < boundsWidth) {
        scrollView.contentOffset = CGPointMake(contentWidth - boundsWidth*2, scrollView.contentOffset.y);
    }
}

#pragma mark - Property

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        for (int i = 1; i <= IMAGE_COUNT; i++) {
            NSString *fileName = [NSString stringWithFormat:@"%i.jpg", i];
            UIImage *image = [UIImage imageNamed:fileName];
            if (nil != image) {
                [_dataArray addObject:image];
            }
            else {
                NSLog(@"image is nil");
            }
        }
        [_dataArray insertObject:[UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", (NSUInteger)IMAGE_COUNT]] atIndex:0];
        [_dataArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", 1]]];
        
        return _dataArray;
    }
    
    return _dataArray;
}

- (NSMutableArray *)imageData
{
    if (_imageData) {
        return _imageData;
    }
    
    NSArray *arr = [self imageURLs];
    _imageData = [NSMutableArray arrayWithArray:arr];
    [_imageData insertObject:arr.lastObject atIndex:0];
    [_imageData addObject:arr.firstObject];
    
    return _imageData;
}

- (NSArray *)imageURLs
{
    NSArray *imageArr = @[
                         @"http://wenwen.sogou.com/p/20100718/20100718135522-650851011.jpg",
                         @"http://img2.3lian.com/2014/f2/123/d/62.jpg",
                         @"http://d.hiphotos.baidu.com/zhidao/pic/item/562c11dfa9ec8a13e028c4c0f603918fa0ecc0e4.jpg",
                         @"http://img4q.duitang.com/uploads/item/201503/02/20150302165008_HPttF.thumb.700_0.png",
                         @"http://e.hiphotos.baidu.com/exp/w=500/sign=f03fa87b39292df597c3ac158c305ce2/7e3e6709c93d70cf5f16c759fbdcd100bba12bf1.jpg"
                         ];
    return imageArr;
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
