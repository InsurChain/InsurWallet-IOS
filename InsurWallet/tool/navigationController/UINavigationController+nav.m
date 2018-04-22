//
//  UINavigationController+nav.m
//  ceshiXNav
//
//  Created by 宗宇辰 on 2017/11/17.
//  Copyright © 2017年 sinosoft. All rights reserved.
//

#import "UINavigationController+nav.h"
#define IS_iPhoneX ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)
@implementation UINavigationController (nav)
- (void)setUpNav:(UIView *)navView navColor:(UIColor *)navColor navImage:(NSString *)navImage{
    for (UIView *view in navView.subviews) {
        if ([NSStringFromClass(view.class) isEqualToString:@"_UIBarBackground"]) {
            for (UIView *view1 in view.subviews) {
                view1.hidden = YES;
                [view1 removeFromSuperview];
            }
            CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, navView.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
            if (navImage.length == 0) {
                if (navColor != [UIColor clearColor]) {
                    UIView *v = [[UIView alloc]initWithFrame:frame];
                    v.backgroundColor = navColor;
                    [view addSubview:v];
                    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(v.frame) - 0.5, SCREEN_WIDTH, 0.5)];
                    [v addSubview:line];
                    line.backgroundColor = ARGBCOLOR(63, 63, 71, 1);
                }
            }else{
                UIImageView *imageV = [[UIImageView alloc]initWithFrame:frame];
                imageV.image = [UIImage imageNamed:navImage];
                [view addSubview:imageV];
            }
            
        }
    }
}
@end
