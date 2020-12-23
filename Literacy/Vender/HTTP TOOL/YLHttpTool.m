//
//  YLHttpTool.m
//
//  Created by Yuri on 16/1/21.
//  Copyright © 2016年 123. All rights reserved.


#import "YLHttpTool.h"

//@interface YLHttpTool()
//@property (nonatomic, strong) ZFPlayerController *player;
//@end

@implementation YLHttpTool

#pragma mark -- POST请求 --
+ (void)POST:(NSString *)URLString
 parameters:(id)parameters
   progress:(void (^)(NSProgress *progress))progress
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure
{
    // 设置请求的  contentType
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 15.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //设置请求头
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
//    [mgr.requestSerializer setValue:Appkey forHTTPHeaderField:@"App-Key"];
//    [mgr.requestSerializer setValue:SoftwareVersion forHTTPHeaderField:@"Software-Version"];
//    [mgr.requestSerializer setValue:ClientType forHTTPHeaderField:@"Client-Type"];
//    [mgr.requestSerializer setValue:[YUserDefaults objectForKey:kuserkey] forHTTPHeaderField:@"User-Key"];
    [mgr.requestSerializer setValue:[YUserDefaults objectForKey:ktoken] forHTTPHeaderField:@"token"];
    
    //设置接受方式
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",nil];

//    @"text/plain",@"text/html",@"image/png", @"application/javascript",
    
    [mgr POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            // 打印下错误信息
            YLog(@"---打印错误信息---%@",error.description);
            
            YLog(@"%ld",error.code)
            
            if(error.code == -1009){
                
                [SVProgressHUD showErrorWithStatus:@"当前无网络，建议检查设备网络状态"];
                [SVProgressHUD dismissWithDelay:1];
                

            }
            else{
                [SVProgressHUD showErrorWithStatus:@"服务器请求失败,请稍候再试"];
                [SVProgressHUD dismissWithDelay:1];

            }
            

            failure(error);
        }
    }];
}

#pragma mark -- GET请求 --
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
   progress:(void (^)(NSProgress *progress))progress
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure
{
    //增加这几行代码；
//    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
//    [securityPolicy setAllowInvalidCertificates:YES];
//    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置请求头
//    [manager.requestSerializer setValue:Appkey forHTTPHeaderField:@"App-Key"];
//    [manager.requestSerializer setValue:SoftwareVersion forHTTPHeaderField:@"Software-Version"];
//    [manager.requestSerializer setValue:ClientType forHTTPHeaderField:@"Client-Type"];
//    [manager.requestSerializer setValue:[YUserDefaults objectForKey:kuserkey] forHTTPHeaderField:@"User-Key"];
    [manager.requestSerializer setValue:[YUserDefaults objectForKey:ktoken] forHTTPHeaderField:@"token"];

    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    //设置接受方式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html",@"image/png", @"application/javascript",nil];
    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:URLString parameters:parameters
    progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }

    }
    success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            // 打印下错误信息
            YLog(@"---打印错误信息---%@",error.description)
            if(error.code == -1009){

                [SVProgressHUD showErrorWithStatus:@"当前无网络，建议检查设备网络状态"];
                [SVProgressHUD dismissWithDelay:1];
                                
            }
            else{
                [SVProgressHUD showErrorWithStatus:@"服务器请求失败,请稍候再试"];
                [SVProgressHUD dismissWithDelay:1];
            }

            failure(error);
        }
    }];
}

/*
+ (void)setPlay{
    //播放录音
    NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"网络" ofType:@"mp3"];
    NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];

    __block ZFPlayerController *player = [ZFPlayerController playerWithPlayerManager: [[ZFAVPlayerManager alloc] init] containerView:[UIView new]];

    player.assetURLs = @[localVideoUrl];
    [player playTheIndex:0];

    player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        [player stop];
        player = nil;
    };
}
*/

// 苹果系统自带的方法
+ (void)ConnectionPOST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure
{
    NSString *encodeStr = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodeStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 3.0f;
    request.HTTPMethod = @"POST";
    //    // 参数
    //    NSMutableDictionary *canshu = [NSMutableDictionary dictionary];
    //    canshu[@"openId"] = @"F7BDFE5C01FF24D77AA0AD582514DD3A";
    //    canshu[@"nickName"] = @"dfgsdf";
    //    canshu[@"cooperativeAccount"] = @"sinaBlog";
    //    canshu[@"icon"] = @"http://qzapp.qlogo.cn/qzapp/100424468/F7BDFE5C01FF24D77AA0AD582514DD3A/100";
    //    canshu[@"loginType"] = @2;
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:parameters options:nil error:nil];
    request.HTTPBody = dataJson;
    //    // 一部请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        success(dataStr);
    }];

}


// 苹果系统自带的get方法
+ (void)ConnectionGET:(NSString *)URLString
            parameters:(id)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure
{
    NSURL *url = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:([NSOperationQueue mainQueue]) completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSDictionary *responseObjc = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        success(responseObjc);
    }];
}



@end



