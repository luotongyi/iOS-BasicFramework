//
//  MLWebController.h
//  BasicFramework
//
//  Created by luoty on 2019/5/15.
//  Copyright © 2019 luoty. All rights reserved.
//

#import "MLBaseController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLWebController : MLBaseController

/**
 用于二级跳转后，执行f一级界面等JS使用
 */
@property (nonatomic,strong)    WKWebView *wkWeb;

/**
 从一级界面传递参数到二级界面
 */
@property (nonatomic,copy   )    id params;

/**
 *  @brief 加载的H5的链接
 **/
@property (nonatomic, copy  )   NSString *url;

/**
 *  @brief 自定义的UA，默认为""
 **/
@property (nonatomic, copy  )   NSString *userAgent;

/**
 *  @brief url的requestHeader里的内容，string形式的key和value，默认@{}
 **/
@property (nonatomic, copy  )   NSDictionary *headerParams;

/**
 *  JS 调用OC 注册 messageHandler 的方法名
 *  window.webkit.messageHandlers.<name>.postMessage(<messageBody>)
 *  eg. @[@"showA",@"showB"];
 *
 *  window.webkit.messageHandlers.<name>.postMessage(<messageBody>)
 *  已存在的默认方法：
 */
@property (nonatomic, copy  )   NSArray<NSString *> *jsNamesArray;

/**
 *  OC调用JS方法
 *  jsMethod js内容
 *  eg. [NSString stringWithFormat:@"writeCardCallback(%@);",[array toJSONString]];
 */
- (void)handleJS:(NSString *)js wkWebView:(WKWebView *)web completionHandler:(nonnull void (^)(id _Nullable response))completion;

@property (nonatomic, copy  )   NSString *webTitle;

@end

NS_ASSUME_NONNULL_END
