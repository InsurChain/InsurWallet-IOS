//
//  navigationController.m
//  ceshiXNav
//
//  Created by 宗宇辰 on 2017/11/17.
//  Copyright © 2017年 sinosoft. All rights reserved.
//

#import "navigationController.h"
#define IS_iPhoneX ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)
@interface navigationController ()<UINavigationControllerDelegate>
@property (nonatomic, weak) id PopDelegate;
@property (nonatomic, strong) UIView *Subview;
@end

@implementation navigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.PopDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
    [UINavigationBar appearance].titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]//,NSFontAttributeName:[UIFont boldSystemFontOfSize:16]
                                                       
                                                       };
//    self.navigationBar.barTintColor = [UIColor blueColor];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self.PopDelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
//        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
