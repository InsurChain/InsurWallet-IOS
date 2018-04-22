//
//  AttributedString.h
//  脚印
//
//  Created by 宗宇辰 on 17/3/7.
//  Copyright © 2017年 宗宇辰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomTools : NSObject
//时间戳转换时间
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;
//七天的时间戳
+ (NSString *)getReferenceDateTimestamp;
//现在时间
+ (NSString *)getCurrentTimestamp;

//提示框
+(void)showView:(UIView *)view Str:(NSString *)str;

@end


