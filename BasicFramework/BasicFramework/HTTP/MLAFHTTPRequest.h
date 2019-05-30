//
//  MLAFHTTPRequest.h
//  BasicFramework
//
//  Created by luoty on 2019/5/28.
//  Copyright © 2019 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLAFRequestItem.h"
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  AFNetworking封装一层，便于业务使用
 */
@interface MLAFHTTPRequest : NSObject

/**
 * requestItem 请求消息体
 * 加解密未封装在此方法里，需要加解密的时候可以自己创建request，再通过AFNetworking发起请求
 * 成功返回
 * 失败返回
 */
+ (void)requestItem:(MLAFRequestItem *)item
       successBlock:(void (^)(NSURLSessionDataTask *task, id responseObject))success
       failureBlock:(void (^)(NSURLSessionDataTask *task, id errorObject))failure;


@end

NS_ASSUME_NONNULL_END
