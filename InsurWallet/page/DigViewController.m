//
//  MainViewController.m
//  InsurWallet
//
//  Created by 宗宇辰 on 2018/2/5.
//  Copyright © 2018年 sinosoft. All rights reserved.
//

#import "DigViewController.h"
#import "LoginViewController.h"
@interface DigViewController ()<UITabBarControllerDelegate>
@property (nonatomic, assign) int i;
@end

@implementation DigViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Login:) name:@"Login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"reload" object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.delegate=self;
    self.webView.backgroundColor = ARGBCOLOR(26, 26, 36, 1);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-self.tabBarController.tabBar.frame.size.height)];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    [self.webView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"webbg.png"]]];
    self.webView.scrollView.bounces = NO;
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@h5/index.html?version=%@",IPURL,app_Version]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.webView];
}
- (void)JSTheGinseng{
    if (TOKEN != nil) {
        NSDictionary *tokenDictionary= [NSDictionary dictionaryWithObjectsAndKeys:TOKEN,@"token",nil];
        SBJson4Writer *writer = [[SBJson4Writer alloc] init];
        NSString *jasonString = [writer stringWithObject:tokenDictionary];
        NSLog(@"====%@",jasonString);
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@');",@"nativeToJs",jasonString]];
    }
}
-(void)Login:(NSNotification *)noto{
    [self JSTheGinseng];
}
-(void)reload:(NSNotification *)noto{
    [_webView reload];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //将tianbai对象指向自身
    self.jsContext[@"jsBridge"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    [self JSTheGinseng];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    // 设置javaScriptContext上下文
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //将tianbai对象指向自身
    self.jsContext[@"jsBridge"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}
#pragma mark  --------js交互方法---------
- (void)jsBridge:(NSString *)callString{
    NSLog(@"Get:%@", callString);
    NSMutableDictionary *dar1 = [NSJSONSerialization JSONObjectWithData: [callString dataUsingEncoding:NSUTF8StringEncoding]options: NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@", dar1);
    dispatch_sync(dispatch_get_main_queue(), ^{
        if ([dar1[@"download"] intValue] != YES) {
            if (TOKEN == nil ) {
                [self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES];
            }else{
                
                SecondaryViewController *SecondaryVC = [[SecondaryViewController alloc]init];
                SecondaryVC.webUrl = dar1[@"url"];
                SecondaryVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:SecondaryVC animated:YES];
            }
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@h5/shareSucc.html",IPURL]]];
        }
        
    });
    
    // 成功回调JavaScript的方法Callback
    JSValue *Callback = self.jsContext[@"jsBridge"];
    [Callback callWithArguments:nil];
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    //单击处理
    UINavigationController *navdid=tabBarController.selectedViewController;//当前状态下已经处于选择状态的vc
    if ([viewController.tabBarItem.title isEqualToString:@"兑换"] || [viewController.tabBarItem.title isEqualToString:@"我的"]) {
        if (TOKEN == nil ) {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [navdid pushViewController:loginVC animated:YES];
        }else{
            return YES;
        }
        return NO;
    }
    return YES;
}
@end
