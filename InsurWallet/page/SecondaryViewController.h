//
//  SecondaryViewController.h
//  InsurWallet
//
//  Created by 宗宇辰 on 2018/2/6.
//  Copyright © 2018年 sinosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@protocol JSObjcDelegate <JSExport>
- (void)jsBridge:(NSString *)callString;
@end
@interface SecondaryViewController : UIViewController<UIWebViewDelegate,JSObjcDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, strong) JSContext *jsContext;
@end
