//
//  MLHTTPCache.m
//  BasicFramework
//
//  Created by luoty on 2019/8/19.
//  Copyright © 2019 luoty. All rights reserved.
//

#import "MLHTTPCache.h"

@implementation MLHTTPCache


// 响应缓存
+ (void)getHTTPCache:(MLRequestCachePolicy)cacheType
                 url:(NSString *)url
              params:(NSDictionary *)params
          withResult:(void (^)(void))resultBlock
{
    //    id object = [WMNetWorkCache httpCacheForURL:url parameters:params];
    //    if (object) {
    //        if (cacheType == WMClientReloadIgnoringLocalCacheData) {//忽略缓存，重新请求
    //            self.result = NO;
    //        } else if (cacheType == WMClientReturnCacheDataDontLoad) {//有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
    //            if (object) {
    //                resultBlock(object,nil);
    //            }
    //            self.result = YES;
    //        } else if (cacheType == WMClientReturnCacheDataElseLoad) {//有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
    //            if (object) {
    //                resultBlock(object,nil);
    //            }
    //            self.result = YES;
    //
    //        } else if (cacheType == WMClientReturnCacheDataThenLoad) {///有缓存就先返回缓存，同步请求数据
    //            if (object) {
    //                resultBlock(object,nil);
    //            }
    //            self.result = NO;
    //        }
    //    }
}

+ (void)setHTTPCache:(MLRequestCachePolicy)cacheType
                 url:(NSString *)url
              params:(NSDictionary *)params
{
    
}

@end
