//
//  InsurWalletHeader.h
//  InsurWallet
//
//  Created by 宗宇辰 on 2018/2/5.
//  Copyright © 2018年 sinosoft. All rights reserved.
//

#ifndef InsurWalletHeader_h
#define InsurWalletHeader_h
#import "DigViewController.h"
#import "ExchangeViewController.h"
#import "MyViewController.h"
#import "DWTabBarController.h"
#import "DWTabBar.h"
#import "navigationController.h"
#import "UINavigationController+nav.h"
#import "XBNetCenter.h"
#import "SBJson4Writer.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "SecondaryViewController.h"
#import "MBProgressHUD+NHAdd.h"
#import "ThreeLevelViewController.h"
#import "UIButton+WebCache.h"
#import "CustomTools.h"
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define ARGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define TOKEN [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]
#define app_Version [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


#define IPURL @"https://wallet.qusukj.com/"

#endif /* InsurWalletHeader_h */
