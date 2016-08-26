//
//  MUSlideMenuViewController.m
//  SlideMenuViewController
//
//  Created by 潘元荣(外包) on 16/8/25.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

#import "MUSlideMenuViewController.h"

typedef NS_ENUM(NSInteger, MUSlideType) {
    MUSlideTypeCenter,
    MUSlideTypeLeft,
    MUSlideTypeRight
};
@interface MUSlideMenuViewController ()<UIGestureRecognizerDelegate>{
    CGPoint _beginPoint;
    UIImageView *_backgroundImage;
}
@property (nonatomic, strong) UIPanGestureRecognizer *press;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, assign) MUSlideType currentSlideType;
@end

@implementation MUSlideMenuViewController
- (UIPanGestureRecognizer *)press{
    if (!_press) {
        _press= [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pressMoveToSliderMenu:)];
        _press.delegate = self;
    }
    return _press;
}
- (UITapGestureRecognizer *)tap{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMoveToCenter:)];
        _tap.delegate = self;
    }
    return _tap;
}
- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:self.view.bounds];
        _coverView.backgroundColor = [UIColor clearColor];
    }
    return _coverView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _backgroundImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
   _backgroundImage.image = [UIImage imageNamed:@"cover_placeholder"];
    [self.view addSubview:_backgroundImage];
    [self.view addGestureRecognizer:self.press];
    self.currentSlideType = MUSlideTypeCenter;
}
- (void)changeBackgroundModel:(NSString*)model{
    if ([model containsString:@"夜间"]) {
        _backgroundImage.image = [UIImage imageNamed:@"cover_placeholder"];
    }else{
        _backgroundImage.image = [UIImage imageNamed:@"sunshine"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)pressMoveToSliderMenu:(UIPanGestureRecognizer*)press{
   CGPoint point = [press locationInView:self.view];
    
    if (press.state == UIGestureRecognizerStateBegan) {
         _beginPoint = point;
    }else if (press.state == UIGestureRecognizerStateEnded){
        if (point.x - _beginPoint.x > 0.0) {
            NSLog(@"left move");
            self.currentSlideType = MUSlideTypeLeft;
        }else if (point.x - _beginPoint.x < -0.0){
            NSLog(@"right move");
            self.currentSlideType = MUSlideTypeRight;
        }
        [self transitionToTargetView];
    }
}
- (void)transitionToTargetView {
    CGAffineTransform mainTransform = CGAffineTransformMake(0.8, 0, 0, 0.8,-0.8*KWidth-self.rightMargin + KWidth, 0);
    UIView *targetView = self.rightViewController.view;
    UIView *middleView = self.middleViewController.view;
    UIViewController *targetViewController = self.rightViewController;
    CGRect rect = CGRectMake(KWidth - _rightMargin, 0, KWidth, KHeight);
    switch (self.currentSlideType) {
        case MUSlideTypeCenter:
            
            break;
        case MUSlideTypeLeft:
            mainTransform = CGAffineTransformMake(0.8, 0, 0, 0.8,0, 0);
            targetView = self.leftViewController.view;
            rect.origin.x =  -self.leftMargin;
            targetViewController = self.leftViewController;
            break;
        case MUSlideTypeRight:
            
        default:
            break;
    }
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:30.0 initialSpringVelocity:6.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        middleView.layer.cornerRadius = 10.0;
        middleView.transform = mainTransform;
        targetView.frame = rect;
        
    } completion:^(BOOL finished) {
        [self.view removeGestureRecognizer:self.press];
        self.press.delegate = nil;
        self.coverView.transform = mainTransform;
        
        [self.view addSubview:self.coverView];
        [self.view bringSubviewToFront:targetView];
        [self.coverView addGestureRecognizer:self.tap];
        [targetViewController didMoveToParentViewController:self];
    }];
    

}
- (void)tapMoveToCenter:(UITapGestureRecognizer*)tap{
    

    UIView *targetView = self.rightViewController.view;
    UIView *middleView = self.middleViewController.view;
    CGRect rect = CGRectMake(KWidth, 0, KWidth, KHeight);
    switch (self.currentSlideType) {
        case MUSlideTypeCenter:
            
            break;
        case MUSlideTypeLeft:
            targetView = self.leftViewController.view;
            rect.origin.x = - KWidth;
            break;
        case MUSlideTypeRight:
            
        default:
            break;
    }

    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:30.0 initialSpringVelocity:6.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        middleView.transform = CGAffineTransformIdentity;
        targetView.frame = rect;
    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
        [self.coverView removeGestureRecognizer:self.tap];
         self.tap.delegate = nil;
        [self.view addGestureRecognizer:self.press];
        [self.middleViewController didMoveToParentViewController:self];
    }];
    
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
