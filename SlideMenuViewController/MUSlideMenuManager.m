//
//  MUSlideMenuManager.m
//  SlideMenuViewController
//
//  Created by 潘元荣(外包) on 16/8/25.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

#import "MUSlideMenuManager.h"
#import <UIKit/UIKit.h>
#import "MUSlideMenuViewController.h"
#import "AppDelegate.h"

@interface MUSlideMenuManager(){

}
@property (nonatomic, strong) MUSlideMenuViewController *mainViewController;
@property (nonatomic, strong) UIViewController *rightViewController;
@property (nonatomic, strong) UIViewController *leftViewController;


@end
@implementation MUSlideMenuManager

- (MUSlideMenuViewController *)mainViewController{
    if (!_mainViewController) {
        _mainViewController = [[MUSlideMenuViewController alloc]init];
    }
    return _mainViewController;
}
+ (id)manager{
    static MUSlideMenuManager *manager = nil;
    static dispatch_once_t token;
    
    if (manager == nil) {
        dispatch_once(&token, ^{
            manager = [[self alloc]init];
        });
    }
    return manager;
}
- (void)changeBackgroundModel:(NSString *)model{
    [self.mainViewController changeBackgroundModel:model];
}
- (void)setLeftViewController:(UIViewController *)viewController leftMargin:(float)leftMargin{
    self.mainViewController.leftMargin = leftMargin;
    
    self.mainViewController.leftViewController = viewController;
    viewController.view.frame = CGRectMake(-KWidth, 0, KWidth, KHeight);
    [self.mainViewController addChildViewController:viewController];
    [self.mainViewController.view addSubview:viewController.view];

}

- (void)setMiddleViewController:(UIViewController *)middleController backGroundImageWithName:(NSString *)imageName{
    self.mainViewController.middleViewController = middleController;
    [self.mainViewController.view addSubview:middleController.view];
    [self.mainViewController addChildViewController:middleController];
    [middleController didMoveToParentViewController:self.mainViewController];
}

- (void)setRigthViewController:(UIViewController *)viewController rightMargin:(float)rightMargin{
    self.mainViewController.rightMargin = rightMargin;
   
    self.mainViewController.rightViewController = viewController;
    viewController.view.frame = CGRectMake(KWidth, 0, KWidth, KHeight);
   
    [self.mainViewController addChildViewController:viewController];
    [self.mainViewController.view addSubview:viewController.view];
    
    
    
}

- (void)addSlideViewContollerOnWindow{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = self.mainViewController;
}

- (void)slideToLeftViewController{
    
}


@end
