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

@interface MLSessionManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;

@end

@implementation MLSessionManager

+ (instancetype)sharedInstance{
    
    static MLSessionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MLSessionManager alloc] init];
        instance.requestSerializer.timeoutInterval = 20;
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
            return;
        }
            break;
        case MLCacheDataElseLoad:
        {
            //有缓存就用缓存，没有缓存就重新请求
            return;
        }
            break;
        case MLCacheDataThenLoad:
        {
            //有缓存先读取缓存，继续请求
        }
            break;
        case MLIgnoringLocalCacheData:
        default:
        {
            //忽略缓存数据直接请求
        }
            break;
    }
    
    if (item.encrypt) {
        //请求参数加密
        
    }
    MLSessionManager *manager = [MLSessionManager sharedInstance];
    if (item.headerParams.count > 0)
    {
        [item.headerParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [manager.requestSerializer setValue:ML_STRING_FORMAT(obj) forHTTPHeaderField:key];
        }];
    }
    switch (item.requestMethod) {
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

@end


