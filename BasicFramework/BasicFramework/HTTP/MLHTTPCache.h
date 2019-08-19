//
//  MLHTTPCache.h
//  BasicFramework
//
//  Created by luoty on 2019/8/19.
//  Copyright © 2019 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MLRequestCachePolicy) {
    MLIgnoringLocalCacheData = 0,   //忽略缓存，重新请求，默认
    MLCacheDataDontLoad,            //有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
    MLCacheDataElseLoad,            //有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
    MLCacheDataThenLoad             //有缓存就先返回缓存，同步请求数据
};

NS_ASSUME_NONNULL_BEGIN

@interface MLHTTPCache : NSObject





@end

NS_ASSUME_NONNULL_END
