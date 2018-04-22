//
//  SecondaryViewController.m
//  InsurWallet
//
//  Created by 宗宇辰 on 2018/2/6.
//  Copyright © 2018年 sinosoft. All rights reserved.
//

#import "SecondaryViewController.h"
#import "AppDelegate.h"
@interface SecondaryViewController ()
@property (nonatomic, copy) NSString *recordUrl;
@end

@implementation SecondaryViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setUpNav:self.navigationController.navigationBar
                               navColor:ARGBCOLOR(26, 26, 36, 1)
                               navImage:@""];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ARGBCOLOR(26, 26, 36, 1);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(returnWithCliked)];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    [self.webView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"webbg.png"]]];
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.bounces = NO;
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    NSURL* url = [NSURL URLWithString:_webUrl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.webView];
}
- (void)returnWithCliked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    UIWebView *web = webView;
    NSString *htmlNum = @"document.getElementsByTagName('title')[0].innerHTML";
    NSString *allHtmlInfo = [web stringByEvaluatingJavaScriptFromString:htmlNum];
    self.title = allHtmlInfo;
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
    if ([dar1[@"loginOut"] intValue] == YES) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"token"];
        [userDefaults synchronize];
        [UIView transitionWithView:self.view.window
                          duration:0.0
                           options: UIViewAnimationOptionTransitionNone
                        animations:^{
                            self.view.window.rootViewController = [[DWTabBarController alloc]init];
                        }
                        completion:nil];
        
    }
    if ([dar1[@"isShare"] intValue] == YES) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"邀请好友" style:UIBarButtonItemStylePlain target:self action:@selector(ShareWithCliked)];
        self.recordUrl = dar1[@"url"];
    }
    if ([dar1[@"reload"] intValue] == YES) {
        NSNotification *notification =[NSNotification notificationWithName:@"reload" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    if ([dar1[@"updateInfo"] intValue] == YES) {
        NSNotification *notification =[NSNotification notificationWithName:@"reload" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    if (dar1[@"goPage"] != nil) {
        SecondaryViewController *SecondaryVC = [[SecondaryViewController alloc]init];
        SecondaryVC.webUrl = dar1[@"goPage"];
        SecondaryVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:SecondaryVC animated:YES];
    }
    if (dar1[@"goinvite"] != nil) {
        SecondaryViewController *SecondaryVC = [[SecondaryViewController alloc]init];
        SecondaryVC.webUrl = dar1[@"goinvite"];
        SecondaryVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:SecondaryVC animated:YES];
    }
    if ([dar1[@"clickInvite"] intValue] == YES) {
        [self loadImageFinished:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dar1[@"imgUrl"]]]]];
    }
    // 成功回调JavaScript的方法Callback
    JSValue *Callback = self.jsContext[@"jsBridge"];
    [Callback callWithArguments:nil];
}
-(void)ShareWithCliked{
    NSDictionary *tokenDictionary= [NSDictionary dictionaryWithObjectsAndKeys:@"",@"",nil];
    SBJson4Writer *writer = [[SBJson4Writer alloc] init];
    NSString *jasonString = [writer stringWithObject:tokenDictionary];
    NSLog(@"====%@",jasonString);
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@');",@"nativeToJs",jasonString]];
}
-(void)currentViewController:(UIViewController *)currentVC toViewController:(UIViewController *)toVC{
    [UIView transitionWithView:currentVC.view.window
                      duration:0.5
                       options: UIViewAnimationOptionTransitionNone
                    animations:^{
                        currentVC.view.window.rootViewController = [[DWTabBarController alloc]init];
                    }
                    completion:nil];
}
- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (error == nil) {
        [CustomTools showView:self.view Str:@"保存成功"];
    }else{
        [CustomTools showView:self.view Str:@"保存失败"];
    }
}
@end
