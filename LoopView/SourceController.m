//
//  SourceController.m
//  LoopView
//
//  Created by 符现超 on 16/1/14.
//  Copyright © 2016年 当当. All rights reserved.
//

#import "SourceController.h"

@interface SourceController ()

@end

@implementation SourceController

#pragma mark - 单例
/**
static SourceController *shareInstance;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[SourceController alloc] init];
    });
    return shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareInstance) {
            shareInstance = [super allocWithZone:zone];
        }
    });
    return shareInstance;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return shareInstance;
}
*/

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor orangeColor];
    
    NSString *indexString = [NSString stringWithFormat:@"%d", self.index];
    self.label.text = indexString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
