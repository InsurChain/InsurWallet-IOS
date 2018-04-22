//
//  ThreeLevelViewController.m
//  InsurWallet
//
//  Created by 宗宇辰 on 2018/2/7.
//  Copyright © 2018年 sinosoft. All rights reserved.
//

#import "ThreeLevelViewController.h"

@interface ThreeLevelViewController ()

@end

@implementation ThreeLevelViewController

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
    
}
@end
