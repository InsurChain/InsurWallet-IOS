//
//  AppDelegate.m
//  InsurWallet
//
//  Created by 宗宇辰 on 2018/2/5.
//  Copyright © 2018年 sinosoft. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[DWTabBarController alloc]init];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (TOKEN != nil) {
        NSLog(@"====%@",TOKEN);
        NSString *StartUrlStr = @"api/v1/app/activate";
        NSMutableDictionary *StartDic = [[NSMutableDictionary alloc]init];
        StartDic [@"Authentication"] = TOKEN;
        [[XBNetCenter share] sendRequestWithMethods:YES withURL:StartUrlStr withParams:StartDic withImagePath:nil withCompletion:^(id responseData, NSError *error, NSInteger Code) {
            NSLog(@"%ld=====%@",(long)Code,responseData);
        }];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
