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
@property (nonatomic, strong) NSMutableSet *viewcontrolllers;

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
        UIPageViewController *pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        pageVC.delegate = self;
        pageVC.dataSource = self;
        pageVC.view.frame = self.view.frame;
        [self addChildViewController:pageVC];
        [self.view addSubview:pageVC.view];
        pageVC;
    });
}

#pragma mark - UIPageViewControllerDataSource && Delegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    return nil;
}

#pragma mark - Property
- (NSMutableSet *)viewcontrolllers
{
    if (!_viewcontrolllers) {
        _viewcontrolllers = ({
            NSMutableSet *mutArr = [[NSMutableSet alloc] init];
            for (NSUInteger i = 0; i < 3; i++) {
                SourceController *vc = SourceController.new;
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
