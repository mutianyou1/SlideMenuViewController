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
@property (nonatomic, strong) UIPanGestureRecognizer *centerPan;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, assign) MUSlideType currentSlideType;
@end

@implementation MUSlideMenuViewController
- (UIPanGestureRecognizer *)pan{
    if (!_pan) {
        _pan= [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMoveToSliderMenu:)];
        _pan.delegate = self;
    }
    return _pan;
}
- (UIPanGestureRecognizer *)centerPan{
    if (!_centerPan) {
        _centerPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(centerViewPanMoveToOriginalView:)];
        _centerPan.delegate = self;
    }
    return _centerPan;
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
    [self.view addGestureRecognizer:self.pan];
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
- (void)panMoveToSliderMenu:(UIPanGestureRecognizer*)pan{
   CGPoint point = [pan locationInView:self.view];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
         _beginPoint = point;
    }else if (pan.state == UIGestureRecognizerStateEnded){
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
- (void)centerViewPanMoveToOriginalView:(UIPanGestureRecognizer*)pan{
    CGPoint point = [pan locationInView:self.view];
    if (pan.state == UIGestureRecognizerStateBegan) {
        _beginPoint = point;
    }else if(pan.state == UIGestureRecognizerStateEnded){
        switch (self.currentSlideType) {
            case MUSlideTypeCenter:
                
                break;
            case MUSlideTypeLeft:
                
                if (point.x - _beginPoint.x < 0) {
                    [self moveToCenterView];
                }
                break;
            case MUSlideTypeRight:
                if (point.x - _beginPoint.x > 0) {
                    [self moveToCenterView];
                }
                break;
            default:
                break;
        }
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
        [self.view removeGestureRecognizer:self.pan];
        self.pan.delegate = nil;
        self.coverView.transform = mainTransform;

        [self.view addSubview:self.coverView];
        [self.coverView addGestureRecognizer:self.tap];
        [self.view bringSubviewToFront:targetView];
        [targetView addGestureRecognizer:self.centerPan];
        [targetViewController didMoveToParentViewController:self];
    }];
    

}
- (void)tapMoveToCenter:(UITapGestureRecognizer*)tap{
    
    [self moveToCenterView];
    
}
- (void)moveToCenterView{
    
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
        [targetView removeGestureRecognizer:self.centerPan];
        [self.view addGestureRecognizer:self.pan];
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
