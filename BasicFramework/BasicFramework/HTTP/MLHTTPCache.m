//
//  MLHTTPCache.m
//  BasicFramework
//
//  Created by luoty on 2019/8/19.
//  Copyright © 2019 luoty. All rights reserved.
//

#import "MLHTTPCache.h"
#import "YYCache.h"

@implementation MLHTTPCache

static NSString *const MLNetworkResponseCache = @"MLNetworkResponseCache";
static YYCache *_dataCache;

+ (void)initialize {
    _dataCache = [YYCache cacheWithName:MLNetworkResponseCache];
}

+ (id)getHTTPCache:(NSString *)url parameters:(NSDictionary *)parameters
{
    NSString *cacheKey = [self cacheKeyWithUrl:url parameters:parameters];
    return [_dataCache objectForKey:cacheKey];
}

+ (void)setHTTPCache:(id)httpData
                 url:(NSString *)url
          parameters:(NSDictionary *)parameters
{
    NSString *cacheKey = [self cacheKeyWithUrl:url parameters:parameters];
    //异步缓存,不会阻塞主线程
    [_dataCache setObject:httpData forKey:cacheKey withBlock:nil];
}

+ (NSInteger)getAllHTTPCacheSize{
    return [_dataCache.diskCache totalCost];
}

+ (void)removeAllHTTPCache{
    [_dataCache.diskCache removeAllObjects];
}

+ (NSString *)cacheKeyWithUrl:(NSString *)url parameters:(NSDictionary *)parameters{
    if(!parameters) {
        return url;
    };
    // 将参数字典转换成字符串
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    // 将URL与转换好的参数字符串拼接在一起,成为最终存储的KEY值
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@",url,paraString];
    return cacheKey;
}

@end
