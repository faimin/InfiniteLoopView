//
//  MMScrollView.m
//  MMUIDemo
//
//  Created by MOMO on 2017/5/5.
//  Copyright © 2017年 MOMO. All rights reserved.
//

#import "ZDCycleScrollView.h"
#import "ZDImageCollectionViewCell.h"

#pragma mark - NSTimer Category

@interface NSTimer (ZDCategory)

+ (NSTimer *)zd_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *))block;

@end

@implementation NSTimer (ZDCategory)

+ (void)executeWithBlock:(NSTimer *)timer {
    if (timer.userInfo) {
        void(^userInfoBlock)(NSTimer *) = timer.userInfo;
        userInfoBlock(timer);
    }
    
}

+ (NSTimer *)zd_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer * _Nonnull))block {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(executeWithBlock:) userInfo:[block copy] repeats:repeats];
    return timer;
}

@end

#pragma mark -
#pragma mark

static NSString * const ZD_ReuseIdentifier = @"ZDImageCollectionViewCell";

@interface ZDCycleScrollView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ZDCycleScrollView

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    NSLog(@"%@-->%@, %s", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __PRETTY_FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    
    __weak typeof(self)weakSelf = self;
    self.timer = [NSTimer zd_scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer *innerTimer) {
        __strong typeof(weakSelf)self = weakSelf;
        [self autoScroll];
    }];
}

- (void)autoScroll {
    if (_dataArray.count == 0) return;
    
    CGFloat itemWidth = ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).itemSize.width;
    
    NSInteger currentIndex = (self.collectionView.contentOffset.x + itemWidth * 0.5) / itemWidth;
    NSInteger targetIndex = currentIndex + 1;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDatasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZDImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZD_ReuseIdentifier forIndexPath:indexPath];
    
    NSUInteger dataCount = [self dataCount];
    NSUInteger index0 = indexPath.row % dataCount;
    NSUInteger index1 = MIN(index0, dataCount - 1);
    
    cell.imageData = self.dataArray[index1];
    
    return cell;
}

//MARK:点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第%zd个", indexPath.row);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat contentWidth = scrollView.contentSize.width;
    CGFloat boundsWidth = self.bounds.size.width;
    if (offsetX >= (contentWidth - boundsWidth)) {
        scrollView.contentOffset = CGPointMake(boundsWidth, scrollView.contentOffset.y);
    }
    else if (offsetX < boundsWidth) {
        scrollView.contentOffset = CGPointMake(contentWidth - boundsWidth*2, scrollView.contentOffset.y);
    }
    
    NSInteger currentPage = scrollView.contentOffset.x / boundsWidth - 1;
    self.pageControl.currentPage = currentPage;
}

#pragma mark - Private Method

- (NSUInteger)dataCount {
    return self.images.count ? : self.imageURLs.count;
}

#pragma mark - Property
//MARK: Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = ({
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            flowLayout.minimumInteritemSpacing = 0;
            flowLayout.minimumLineSpacing = 0;
            flowLayout.itemSize = self.bounds.size;
            
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
            collectionView.scrollsToTop = NO;
            collectionView.dataSource = self;
            collectionView.delegate = self;
            collectionView.pagingEnabled = YES;
            collectionView.showsHorizontalScrollIndicator = NO;
            collectionView.showsVerticalScrollIndicator = NO;
            [collectionView registerClass:NSClassFromString(ZD_ReuseIdentifier) forCellWithReuseIdentifier:ZD_ReuseIdentifier];
            collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            //MARK:显示第二张图片,因为在源数据中数组前后分别添加了最后一张和第一张,原理和前2种大同小异
            collectionView.contentOffset = CGPointMake(CGRectGetWidth(collectionView.frame), collectionView.contentOffset.y);
            
            collectionView;
        });
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:(CGRect){0, CGRectGetHeight(self.bounds) - 80, CGRectGetWidth(self.bounds), 20}];
        _pageControl.numberOfPages = [self dataCount];
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
        _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        
    }
    return _pageControl;
}

- (NSMutableArray *)dataArray {
    //NSAssert(self.imageURLs || self.images, @"没有数据");
    
    if (_dataArray.count == 0) {
        if (self.images.count > 0) {
            _dataArray = self.images.mutableCopy;
            [_dataArray insertObject:self.images.lastObject atIndex:0];
            [_dataArray addObject:self.images.firstObject];
        }
        else if (self.imageURLs.count > 0) {
            _dataArray = self.imageURLs.mutableCopy;
            [_dataArray insertObject:self.imageURLs.lastObject atIndex:0];
            [_dataArray addObject:self.imageURLs.firstObject];
        }
        else {
            _dataArray = @[].mutableCopy;
        }
    }
    
    return _dataArray;
}

//MARK: Setter

- (void)setImages:(NSArray<UIImage *> *)images {
    if (_images != images) {
        _images = images;
    }
    
    if (images.count > 0) {
        self.pageControl.numberOfPages = images.count;
        [self.collectionView reloadData];
    }
}

- (void)setImageURLs:(NSArray<NSString *> *)imageURLs {
    if (_imageURLs != imageURLs) {
        _imageURLs = imageURLs;
    }
    
    if (imageURLs.count > 0) {
        self.pageControl.numberOfPages = imageURLs.count;
        [self.collectionView reloadData];
    }
}

@end










