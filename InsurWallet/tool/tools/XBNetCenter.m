//
//  XBNetCenter.m
//  xiubo2.0
//
//  Created by 王芝刚 on 16/1/11.
//  Copyright © 2016年 王芝刚. All rights reserved.
//

#import "XBNetCenter.h"
static XBNetCenter *_netCenter = nil;
@interface XBNetCenter ()

@property (nonatomic, strong)UIWindow *window;
@property (nonatomic, assign) NSUInteger i;
@end

@implementation XBNetCenter

- (void)viewDidLoad {
    [super viewDidLoad];
}

+(XBNetCenter *)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _netCenter = [[XBNetCenter alloc]init];
        
    });
    return _netCenter;
}
//method判断请求方式，url数据请求URL，params数据请求参数， imagePath图片获取，completion数据回调
-(void)sendRequestWithMethods:(BOOL)method withURL:(NSString *)url withParams:(NSDictionary *)params withImagePath:(NSData *)imagePath withCompletion:(RequestCompletion)completion
{
    
    NSMutableDictionary *tmpParams = [NSMutableDictionary dictionaryWithDictionary:params];
    //拼接URL
    NSString *baseUrl=[NSString stringWithFormat:@"https://wallet.qusukj.com/%@",url];
    //判断请求你方式，YES为POST方式，NO为GET方式
    if (method)
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:tmpParams[@"Authentication"] forHTTPHeaderField:@"Authentication"];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.securityPolicy.allowInvalidCertificates = YES;
        [manager.securityPolicy setValidatesDomainName:NO];
        [manager POST:baseUrl
           parameters:tmpParams
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            if(imagePath != nil && imagePath.length>0){
                [formData appendPartWithFileData:imagePath
                                            name:@"contentBG"
                                        fileName:@"surfacePlot1.png"
                                        mimeType:@"image/png"];
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSInteger statusCode = response.statusCode;
            NSDictionary *allHeaders = response.allHeaderFields;
            NSLog(@"%ld,%@",(long)statusCode,allHeaders);
            completion(responseObject,nil,statusCode);//回调参数
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"===%@",error);
            if (_i < 3)//网络链接失败重新调用这个方法
            {
                _i++;
                [self sendRequestWithMethods:method
                                     withURL:url
                                  withParams:params
                               withImagePath:imagePath
                              withCompletion:^(id responseData, NSError *error, NSInteger Code) {
                                  completion(responseData,nil,Code);
                              }];
            }
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSInteger statusCode = response.statusCode;
            NSDictionary *allHeaders = response.allHeaderFields;
            NSLog(@"%ld,%@",(long)statusCode,allHeaders);
            completion(nil,error,statusCode);
            
        }];
    }
    else
    {
        //GET方式
        baseUrl=[NSString stringWithFormat:@"%@?vc=2.0?ai=ios",baseUrl];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:baseUrl
          parameters:nil
            progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSInteger statusCode = response.statusCode;
            NSDictionary *allHeaders = response.allHeaderFields;
            NSLog(@"%ld,%@",(long)statusCode,allHeaders);
            completion(responseObject,nil,statusCode);//回调参数
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSInteger statusCode = response.statusCode;
            NSDictionary *allHeaders = response.allHeaderFields;
            NSLog(@"%ld,%@",(long)statusCode,allHeaders);
            completion(nil,error,statusCode);
        }];
    }
}
@end
