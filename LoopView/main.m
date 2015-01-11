//
//  main.m
//  LoopView
//
//  Created by 符现超 on 15/1/10.
//  Copyright (c) 2015年 当当. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        int retValue = 0;
        @try {
            retValue = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"exception reason: %@",exception.reason);
            NSLog(@"exception debugDescription: %@",exception.debugDescription);
            NSLog(@"exception callStackSymbols: %@",exception.callStackSymbols);
        }
        @finally {
            //
        }
        return retValue;
    }
}
