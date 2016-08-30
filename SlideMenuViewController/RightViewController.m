//
//  RightViewController.m
//  SlideMenuViewController
//
//  Created by 潘元荣(外包) on 16/8/25.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIScrollView *photoScrollView;
@end

@implementation RightViewController
- (UIScrollView *)photoScrollView{
    if (!_photoScrollView) {
        _photoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, 200*KWidthScale, 100*KHeightScale)];
        _photoScrollView.delegate = self;
        _photoScrollView.pagingEnabled = YES;
        _photoScrollView.showsHorizontalScrollIndicator = NO;
        _photoScrollView.showsVerticalScrollIndicator = NO;
        _photoScrollView.contentSize = CGSizeMake(200*KWidthScale*4, 0);
    }
    return _photoScrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.photoScrollView];
    [self addPhotos];
}

- (void)addPhotos{
    for (int i = 0; i < 4; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i*200*KWidthScale, 0, 200*KWidthScale, 100*KHeightScale)];
        view.backgroundColor = [UIColor colorWithRed:(i+1)*40/255.0 green:30.0/255.0 blue:60.0/255.0 alpha:1];
        [self.photoScrollView addSubview:view];
    }
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
