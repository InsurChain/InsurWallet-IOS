//
//  ExchangeViewController.m
//  InsurWallet
//
//  Created by 宗宇辰 on 2018/2/5.
//  Copyright © 2018年 sinosoft. All rights reserved.
//

#import "ExchangeViewController.h"

@interface ExchangeViewController ()

@end

@implementation ExchangeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setUpNav:self.navigationController.navigationBar
                               navColor:ARGBCOLOR(26, 26, 36, 1)
                               navImage:@""];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换";
    self.view.backgroundColor = ARGBCOLOR(26, 26, 36, 1);
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-self.tabBarController.tabBar.frame.size.height)];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    [self.webView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"webbg.png"]]];
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.bounces = NO;
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@h5/change.html",IPURL]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.webView];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //将tianbai对象指向自身
    self.jsContext[@"jsBridge"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
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
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSMutableDictionary *dar1 = [NSJSONSerialization JSONObjectWithData: [callString dataUsingEncoding:NSUTF8StringEncoding]options: NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@", dar1);
        SecondaryViewController *SecondaryVC = [[SecondaryViewController alloc]init];
        SecondaryVC.webUrl = dar1[@"url"];
        SecondaryVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:SecondaryVC animated:YES];
    });
    
    // 成功回调JavaScript的方法Callback
    JSValue *Callback = self.jsContext[@"jsBridge"];
    [Callback callWithArguments:nil];
}

@end
