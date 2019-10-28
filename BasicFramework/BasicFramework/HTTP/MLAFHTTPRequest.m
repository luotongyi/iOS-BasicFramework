//
//  MLAFHTTPRequest.m
//  BasicFramework
//
//  Created by luoty on 2019/5/28.
//  Copyright © 2019 luoty. All rights reserved.
//

#import "MLAFHTTPRequest.h"
#import "SVProgressHUD.h"
#import "MLHTTPCache.h"
#import <AFNetworking/AFNetworking.h>

@interface MLSessionManager : AFHTTPSessionManager

+ (instancetype _Nullable )sharedInstance;

@end

@implementation MLSessionManager

+ (instancetype)sharedInstance{
    
    static MLSessionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MLSessionManager alloc] init];
        instance.requestSerializer.timeoutInterval = 20;
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/javascript", @"image/png", nil];
        instance.requestSerializer = [AFHTTPRequestSerializer serializer];
        instance.responseSerializer = [AFHTTPResponseSerializer serializer];
//        sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
//        不推荐用于生产
//        instance.securityPolicy.allowInvalidCertificates = YES ;
    });
    return instance;
}

@end


@implementation MLAFHTTPRequest

+ (void)requestItem:(MLAFRequestItem *)item
       successBlock:(void (^)(NSURLSessionDataTask *task, id responseObject))success
       failureBlock:(void (^)(NSURLSessionDataTask *task, id errorObject))failure
{
    
    if (item.showDialog) {
        //请求等待框
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
    }
    
    NSString *urlPath = [item.serverUrl stringByAppendingString:item.functionPath];
    id requestParams = item.requestParams ? item.requestParams : @{};
    switch (item.cacheType) {
        case MLCacheDataDontLoad:
        {
            //有缓存就用缓存，没有缓存就不发请求
//            id object = [MLHTTPCache getHTTPCache:urlPath parameters:requestParams];
//            if (object) {
//                success(nil, object);
//                return;
//            }
//            else{
//                failure(nil, @{});
//                return;
//            }
//            return;
        }
            break;
        case MLCacheDataElseLoad:
        {
            //有缓存就用缓存，没有缓存就重新请求
//            id object = [MLHTTPCache getHTTPCache:urlPath parameters:requestParams];
//            if (object) {
//                success(nil, object);
//                return;
//            }
        }
            break;
        case MLCacheDataThenLoad:
        {
            //有缓存先读取缓存，继续请求
//            id object = [MLHTTPCache getHTTPCache:urlPath parameters:requestParams];
//            if (object) {
//                success(nil, object);
//            }
        }
            break;
        case MLIgnoringLocalCacheData:
        default:
            //忽略缓存数据直接请求
            break;
    }
    
    MLSessionManager *manager = [MLSessionManager sharedInstance];
    if (item.headerParams.count > 0)
    {
        [item.headerParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [manager.requestSerializer setValue:ML_STRING_FORMAT(obj) forHTTPHeaderField:key];
        }];
    }
    switch (item.dataEncodingType) {
        case ML_Encoding_JSON:
            if (![manager.requestSerializer isKindOfClass:[AFJSONRequestSerializer class]]) {
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
            }
            break;
        case ML_Encoding_PList:
            if (![manager.requestSerializer isKindOfClass:[AFPropertyListRequestSerializer class]]) {
                manager.requestSerializer = [AFPropertyListRequestSerializer serializer];
            }
            break;
        case ML_Encoding_URL:
        default:
            if (![manager.requestSerializer isKindOfClass:[AFHTTPRequestSerializer class]]) {
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            }
            break;
    }
    
    switch (item.requestMethod) {
        case MLHTTP_POST_EncodeBody: //或者直接操作AFNetworking，修改源码
        {
            NSURL *url = [NSURL URLWithString:urlPath];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
            [request setHTTPMethod:@"POST"];
            //先讲requestParams转为string，然后加密，然后讲加密后的string转为data
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestParams options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSString *encodeParams = @"";
            //将转为data的参数设置为body体
            [request setHTTPBody:[encodeParams dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                
            } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                
            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                [SVProgressHUD dismiss];
                if (error) {
                    failure(nil,error);
                }
                else {
                //缓存数据
//                if (responseObject) {
//                    [MLHTTPCache setHTTPCache:responseObject url:urlPath parameters:requestParams];
//                }
                    success(nil, responseObject);
                }
            }];
            [task resume];
        }
            break;
        case MLHTTP_Downdload:
        {
            /* 下载地址 */
            NSURL *url = [NSURL URLWithString:urlPath];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlPath]];
            
            NSString *filePath = [item.filePath stringByAppendingPathComponent:url.lastPathComponent];
            
            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                
                NSLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100);
                
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                
                /* 设定下载到的位置 */
                return [NSURL fileURLWithPath:filePath];
                
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {

                [SVProgressHUD dismiss];
                NSLog(@"文件下载结束");
                if (error) {
                    failure(nil, error);
                }
                else {
                    success(nil, @{});
                }
            }];
            [downloadTask resume];
        }
            break;
        case MLHTTP_FormData:
        {
            [manager POST:urlPath parameters:requestParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
//                for (NSString *key in item.formDataParams)
//                {
//                    id object = [item.formDataParams objectForKey:key];
//                    [formData appendPartWithFileData:object name:key fileName:@"image.png" mimeType:@"multipart/form-data"];
//                }
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //请求结束，等待框消失，数据返回给上层
                [SVProgressHUD dismiss];
                //缓存数据
//                if (responseObject) {
//                    [MLHTTPCache setHTTPCache:responseObject url:urlPath parameters:requestParams];
//                }
                success(task, responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //请求结束，等待框消失，数据返回给上层
                [SVProgressHUD dismiss];
                failure(task, error);
            }];
        }
            break;
        case MLHTTP_GET:
        {
            [manager GET:urlPath parameters:requestParams progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //请求结束，等待框消失，数据返回给上层
                [SVProgressHUD dismiss];
                //缓存数据
//                if (responseObject) {
//                    [MLHTTPCache setHTTPCache:responseObject url:urlPath parameters:requestParams];
//                }
                success(task, responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //请求结束，等待框消失，数据返回给上层
                [SVProgressHUD dismiss];
                failure(task, error);
            }];
        }
            break;
        case MLHTTP_POST:
        default:
        {
            [manager POST:urlPath parameters:requestParams progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //请求结束，等待框消失，数据返回给上层
                [SVProgressHUD dismiss];
                //缓存数据
//                if (responseObject) {
//                    [MLHTTPCache setHTTPCache:responseObject url:urlPath parameters:requestParams];
//                }
                success(task, responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //请求结束，等待框消失，数据返回给上层
                [SVProgressHUD dismiss];
                failure(task, error);
            }];
        }
            break;
    }
}

+ (void)startCheckNetworking:(void (^)(NSInteger status))statusBlock
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                statusBlock(0);
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                statusBlock(1);
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                statusBlock(2);
                break;
            case AFNetworkReachabilityStatusUnknown:
            default:
                statusBlock(-1);
                break;
        }
    }];
    [manager startMonitoring];
}

+ (void)stopCheckNetwoking
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager stopMonitoring];
}

@end


