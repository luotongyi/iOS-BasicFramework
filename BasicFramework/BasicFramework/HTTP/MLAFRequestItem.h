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
    MLHTTP_FormData,         //MultipartFormData请求，上传图片文件使用
    MLHTTP_Downdload,        //文件下载
    MLHTTP_POST_EncodeBody,  //body加密
};

typedef NS_ENUM(NSUInteger, MLDataEncodingType) {
    ML_Encoding_URL = 0,         //请求参数编码方式，默认
    ML_Encoding_JSON,            //JSON格式请求
    ML_Encoding_PList,           //属性w列表方式
};

typedef NS_ENUM(NSUInteger, MLRequestCachePolicy) {
    MLIgnoringLocalCacheData = 0,   //忽略缓存，重新请求，默认
    MLCacheDataDontLoad,            //有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
    MLCacheDataElseLoad,            //有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
    MLCacheDataThenLoad             //有缓存就先返回缓存，同步请求数据
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
 http请求的缓存策略，默认MLIgnoringLocalCacheData，忽略缓存
 */
@property (nonatomic, assign)   MLRequestCachePolicy cacheType;

/**
 * http请求的头参数，默认@{}，没有参数
 */
@property (nonatomic, strong)   NSDictionary *headerParams;

/**
 *  是否有网络等待框，YES展示，NO不展示，默认为YES
 */
@property (nonatomic, assign)   BOOL         showDialog;

/**
 *  请求参数编码方式，默认 ML_Encoding_URL
 */
@property (nonatomic, assign)   MLDataEncodingType  dataEncodingType;

/**
 *  文件上传入参，Multi-Part
 *  在app中多用于图片上传操作
 *  默认：@{}
 */
@property (nonatomic, strong) NSDictionary *formDataParams;

/**
 *  filePath，文件存储路径，默认：Documents/url.lastPathComponent 文件夹
 *  在app中多用于文件下载操作
 */
@property (nonatomic, copy  ) NSString *filePath;

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
