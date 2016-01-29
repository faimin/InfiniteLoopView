//
//  FourViewController.m
//  LoopView
//
//  Created by 符现超 on 16/1/14.
//  Copyright © 2016年 当当. All rights reserved.
//

#import "FourViewController.h"
#import "SourceController.h"

@interface FourViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic, strong) UIPageViewController *pageVC;
@property (nonatomic, strong) NSMutableArray *viewcontrolllers;

///添加此属性是为了解决:Unbalanced calls to begin/end appearance transitions for <SourceController>
///的问题
@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation FourViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self settingVC];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)settingVC
{
    self.pageVC = ({
        //NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMid)};
        //UIPageViewController *pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        
        //NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
        UIPageViewController *pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        pageVC.delegate = self;
        pageVC.dataSource = self;
        pageVC.view.frame = self.view.frame;
        
        SourceController *sourceVC = [self viewControllerAtIndex:0];
        [pageVC setViewControllers:@[sourceVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        [self addChildViewController:pageVC];
        [self.view addSubview:pageVC.view];
        [pageVC didMoveToParentViewController:self];
        pageVC;
    });
    
}

#pragma mark - UIPageViewControllerDataSource && Delegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.isAnimating) {
        return nil;
    }
    int index = ((SourceController *)viewController).index;
    return [self viewControllerAtIndex:--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.isAnimating) {
        return nil;
    }
    int index = ((SourceController *)viewController).index;
    return [self viewControllerAtIndex:++index];
}

//- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
//{
//    self.isAnimating = NO;
//    if ((orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationPortraitUpsideDown)) {
//        [pageViewController setViewControllers:@[self.viewcontrolllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
//        return UIPageViewControllerSpineLocationMin;
//    } else {
//        [pageViewController setViewControllers:self.viewcontrolllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
//        return UIPageViewControllerSpineLocationMid;
//    }
//}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    self.isAnimating = YES;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (finished || completed) {
        self.isAnimating = NO;
    }
}

#pragma mark - Private Method

- (__kindof UIViewController *)viewControllerAtIndex:(int)index
{
    if (index < 0) {
        index = 9;
    } else if (index > 9) {
        index = 0;
    }
    SourceController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([SourceController class])];
    vc.index = index;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg", index]];
    vc.imageView.image = image;
    return vc;
}

#pragma mark - Property

- (NSMutableArray *)viewcontrolllers
{
    if (!_viewcontrolllers) {
        _viewcontrolllers = ({
            NSMutableArray *mutArr = [[NSMutableArray alloc] init];
            for (NSUInteger i = 0; i < 2; i++) {
                SourceController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([SourceController class])];
                switch (i) {
                    case 0:
                        //vc.view.backgroundColor = [UIColor redColor];
                        break;
                    case 1:
                        //vc.view.backgroundColor = [UIColor greenColor];
                        break;
                }
                [mutArr addObject:vc];
            }
            mutArr;
        });
    }
    return _viewcontrolllers;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
