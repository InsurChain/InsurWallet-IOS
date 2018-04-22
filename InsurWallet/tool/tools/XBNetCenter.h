//
//  XBNetCenter.h
//  xiubo2.0
//
//  Created by 王芝刚 on 16/1/11.
//  Copyright © 2016年 王芝刚. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^RequestCompletion)(id responseData,NSError *error,NSInteger Code);
@interface XBNetCenter : UIViewController
//单例
+(XBNetCenter *)share;

//method判断请求方式 YES为POST方式，NO为GET方式 ，url数据请求URL，params数据请求参数， imagePath图片获取，completion数据回调 
-(void)sendRequestWithMethods:(BOOL)method withURL:(NSString *)url withParams:(NSDictionary *)params withImagePath:(NSData *)imagePath withCompletion:(RequestCompletion)completion;

@end
