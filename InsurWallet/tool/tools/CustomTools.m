//
//  AttributedString.m
//  脚印
//
//  Created by 宗宇辰 on 17/3/7.
//  Copyright © 2017年 宗宇辰. All rights reserved.
//

#import "CustomTools.h"

@implementation CustomTools


+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
+ (NSString *)getReferenceDateTimestamp{
    NSDate * date = [NSDate date];
    NSDate* dat = [NSDate dateWithTimeInterval:-8*24*60*60 sinceDate:date];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}
+ (NSString *)getCurrentTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}

+(void)showView:(UIView *)view Str:(NSString *)str{
    [MBProgressHUD showTitleToView:view
                           postion:NHHUDPostionCenten
                             title:str];
}
@end
