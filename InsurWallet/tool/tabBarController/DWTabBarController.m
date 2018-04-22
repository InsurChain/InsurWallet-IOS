//
//  DWTabBarController.m
//  DWCustomTabBarDemo
//
//  Created by Damon on 10/20/15.
//  Copyright © 2015 damonwong. All rights reserved.
//

#import "DWTabBarController.h"

#define DWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0] //用10进制表示颜色，例如（255,255,255）黑色
#define DWRandomColor DWColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

@implementation DWTabBarController

#pragma mark -
#pragma mark - Life Cycle

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    // 设置 TabBarItemTestAttributes 的颜色。
    [self setUpTabBarItemTextAttributes];
    
    // 设置子控制器
    [self setUpChildViewController];
    
    // 处理tabBar，使用自定义 tabBar 添加 发布按钮
    [self setUpTabBar];
    
    

    //设置导航控制器颜色为黄色
//    [[UINavigationBar appearance] lt_setBackgroundColor:DWColor(67, 76, 85)];
    
//    [self.tabBar setClipsToBounds:YES];
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   ARGBCOLOR(100, 103, 138, 1).CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundImage:[self imageWithColor:DWColor(26, 26, 36)]];
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark -
#pragma mark - Private Methods
/**
 *  利用 KVC 把 系统的 tabBar 类型改为自定义类型。
 */
- (void)setUpTabBar{
    
    [self setValue:[[DWTabBar alloc] init] forKey:@"tabBar"];
}
/**
 *  tabBarItem 的选中和不选中文字属性
 */
- (void)setUpTabBarItemTextAttributes{
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = DWColor(255, 255, 255);
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12.0];
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = DWColor(68, 119, 255);
    selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12.0];
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
}
/**
 *  添加子控制器，我这里值添加了4个，没有占位自控制器
 */
- (void)setUpChildViewController{

    [self addOneChildViewController:[[navigationController alloc]initWithRootViewController:[[DigViewController alloc]init]]
                          WithTitle:@"挖矿"
                          imageName:@"冶金矿产拷贝-1"
                  selectedImageName:@"冶金矿产拷贝"];
    
    [self addOneChildViewController:[[navigationController alloc]initWithRootViewController:[[ExchangeViewController alloc] init]]
                          WithTitle:@"兑换"
                          imageName:@"iconfont_voice-1"
                  selectedImageName:@"iconfont_voice"];
    [self addOneChildViewController:[[navigationController alloc]initWithRootViewController:[[MyViewController alloc] init]]
                          WithTitle:@"我的"
                          imageName:@"钱包-1"
                  selectedImageName:@"钱包"];
}
/**
 *  添加一个子控制器
 *
 *  @param viewController    控制器
 *  @param title             标题
 *  @param imageName         图片
 *  @param selectedImageName 选中图片
 */
- (void)addOneChildViewController:(UIViewController *)viewController WithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    viewController.tabBarItem.title         = title;
    viewController.tabBarItem.image         = [UIImage imageNamed:imageName];
    UIImage *image = [UIImage imageNamed:selectedImageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = image;
    
    [self addChildViewController:viewController];
    
}
//这个方法可以抽取到 UIImage 的分类中
- (UIImage *)imageWithColor:(UIColor *)color
{
    NSParameterAssert(color != nil);
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
