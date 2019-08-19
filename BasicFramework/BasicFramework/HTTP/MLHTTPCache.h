//
//  MLHTTPCache.h
//  BasicFramework
//
//  Created by luoty on 2019/8/19.
//  Copyright © 2019 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLHTTPCache : NSObject

/**
 *  缓存网络数据,根据请求的 url与parameters
 *  做KEY存储数据, 这样就能缓存多级页面的数据
 *
 *  @param httpData   服务器返回的数据
 *  @param url        请求URL地址
 *  @param parameters 请求参数
 */
+ (void)setHTTPCache:(id)httpData url:(NSString *)url parameters:(NSDictionary *)parameters;

/**
 *  根据请求的 URL与parameters 取出缓存数据
 *
 *  @param url        请求的url
 *  @param parameters 请求的参数
 *
 *  @return 缓存的服务器数据
 */
+ (id)getHTTPCache:(NSString *)url parameters:(NSDictionary *)parameters;

/**
 *  获取网络缓存的总大小 bytes(字节)
 */
+ (NSInteger)getAllHTTPCacheSize;

/**
 *  删除所有网络缓存,
 */
+ (void)removeAllHTTPCache;

@end

NS_ASSUME_NONNULL_END
