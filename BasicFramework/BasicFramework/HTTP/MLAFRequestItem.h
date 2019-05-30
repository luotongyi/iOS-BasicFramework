//
//  MLAFRequestItem.h
//  BasicFramework
//
//  Created by luoty on 2019/5/28.
//  Copyright © 2019 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MLHTTPMethod) {
    MLHTTP_POST = 0,         //POST请求，默认
    MLHTTP_GET,              //GET请求
};

@interface MLAFRequestItem : NSObject

/**
 * http请求，host地址，默认@""
 * eg，@"http://www.baidu.com"
 */
@property (nonatomic, copy  )   NSString *serverUrl;

/**
 * http请求的路径，默认@""
 * eg, @"/api/fm/login"
 */
@property (nonatomic, copy  )   NSString *functionPath;

/**
 * http请求的参数，默认nil，没有参数
 */
@property (nonatomic, strong)   id requestParams;

/**
 * http请求的头参数，默认@{}，没有参数
 */
@property (nonatomic, strong)   NSDictionary *headerParams;

/**
 *  是否有网络等待框，YES展示，NO不展示，默认为YES
 */
@property (nonatomic, assign)   BOOL         showDialog;

/**
 *  是否开启参数加密，默认NO
 */
@property (nonatomic, assign)   BOOL         encrypt;

/**
 * 当开启加密时，使用的加密key，默认@""
 */
@property (nonatomic, copy  )   NSString     *encryptKey;

/**
 * http请求的方式，默认post请求
 */
@property (nonatomic, assign)   MLHTTPMethod requestMethod;

/**
 * http请求时间，默认时间20s
 */
@property (nonatomic, assign, readonly)   NSInteger timeInterval;


@end

NS_ASSUME_NONNULL_END
