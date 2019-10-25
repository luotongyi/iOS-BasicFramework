//
//  MLWebController.m
//  BasicFramework
//
//  Created by luoty on 2019/5/15.
//  Copyright © 2019 luoty. All rights reserved.
//

#import "MLWebController.h"
#import "WebViewJavascriptBridge.h"


@interface MLWebController ()<WKNavigationDelegate,WKScriptMessageHandler>
{
    NSMutableURLRequest *webRequest;
    WKWebViewConfiguration *wkConfig;
    
    NSMutableArray *jsArray;
}
@property (nonatomic, strong)   WebViewJavascriptBridge* bridge;

@property (nonatomic, strong)   WKWebView *wkWebView;

@property (nonatomic, strong)   UIProgressView *myProgressView;
@property (nonatomic, strong)   UIActivityIndicatorView *defaultLoadingView;

@end

@implementation MLWebController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _url = @"";
        _userAgent = @"";
        _params = @"";
        _headerParams = @{};
        jsArray = [NSMutableArray array];
        _jsNamesArray = @[
                          @"AIOpenWebPage", //打开新web容器
                          @"AIWebGoback",   //web容器返回
                          @"AIWebRefresh",  //web刷新界面
                          @"AIWebClose",    //web容器关闭
                          @"AIGetParams"    //获取上一个web容器传过来的参数
                          ];                 //现实加载等待框
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [jsArray addObjectsFromArray:_jsNamesArray];
    
    [self createWebView];
    [self createLoadingView];
    
    _myProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, ML_SCREEN_WIDTH, 0)];
    _myProgressView.tintColor = [UIColor blueColor];
    _myProgressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:_myProgressView];
    
    [self loadUrl];
    
    [self createBarItems];
}

#pragma -mark 初始化wkWebView
- (void)createWebView
{
    wkConfig = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    for (NSString *jsName in jsArray) {
        [userContentController addScriptMessageHandler:self name:ML_STRING_FORMAT(jsName)];
    }
    wkConfig.userContentController = userContentController;
    
    _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, ML_NAVBAR_HEIGHT, ML_SCREEN_WIDTH, ML_SCREEN_HEIGHT-ML_NAVBAR_HEIGHT) configuration:wkConfig];
    _wkWebView.navigationDelegate = self;
    [self.view addSubview:_wkWebView];
    
    [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    ML_WEAK_OBJ(self)
    if (@available(iOS 12.0, *)){
        NSString *baseAgent = [_wkWebView valueForKey:@"applicationNameForUserAgent"];
        NSString *userAgent = [NSString stringWithFormat:@"%@ %@",baseAgent,_userAgent];
        [_wkWebView setValue:userAgent forKey:@"applicationNameForUserAgent"];
    }
    [_wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSString *newUA = [NSString stringWithFormat:@"%@ %@",result,weakself.userAgent];
        weakself.wkWebView.customUserAgent = newUA;
    }];
    [self bridgeHandler];
}

- (void)bridgeHandler{
    ML_WEAK_OBJ(self)
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_wkWebView];
    [_bridge setWebViewDelegate:self];
    
    [_bridge registerHandler:@"busi.openLink" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *url = ML_STRING_FORMAT(data[@"url"]);
        id param = data[@"params"];
        if (!param) {
            param = @{};
        }
        MLWebController *web = [MLWebController new];
        web.url = url;
        web.params = param;
        [weakself.navigationController pushViewController:web animated:YES];
        
        NSDictionary *callbackDict = @{@"code":@"0",@"msg":@"跳转成功！",@"result":@{}};
        responseCallback(callbackDict);
    }];
}

#pragma mark - 加载返回、刷新按钮
- (void)createBarItems
{
    ML_WEAK_OBJ(self)
    MLNavBarItem *backItem = [MLNavBarItem new];
    [backItem setItemHandler:^{
        [weakself goWebHistory];
    }];
    backItem.itemImage = [UIImage imageNamed:@"icon_home_"];
    if (self.navigationController.viewControllers.count > 1) {
        [self.navBar addLeftItems:@[backItem]];
    }
}

#pragma -mark 加载等待框
- (void)createLoadingView
{
    _defaultLoadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_defaultLoadingView];
    _defaultLoadingView.center = self.view.center;
}

- (void)startLoading
{
    [_defaultLoadingView startAnimating];
    _defaultLoadingView.hidden = NO;
}

- (void)stopLoding
{
    [_defaultLoadingView stopAnimating];
    _defaultLoadingView.hidden = YES;
}

#pragma -mark dealloc
- (void)dealloc
{
    for (NSString *jsName in jsArray) {
        [wkConfig.userContentController removeScriptMessageHandlerForName:ML_STRING_FORMAT(jsName)];
    }
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    _wkWebView.navigationDelegate = nil;
}

#pragma mark - event response
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.myProgressView.alpha = 1.0f;
        [self.myProgressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.myProgressView.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self.myProgressView setProgress:0 animated:NO];
                             }];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma -mark web请求
- (void)loadUrl
{
    NSString *urlString = [_url stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    _url = urlString;
    
    if (_url && _url.length > 0)
    {
        if (![_url hasPrefix:@"http"]) {
            [self loadLocalHtml:_url];
        }
        else{
            if (!_headerParams || [_headerParams isKindOfClass:[NSString class]]) {
                _headerParams = @{};
            }
            webRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
            NSArray *headerKeys = _headerParams.allKeys;
            for (NSString *key in headerKeys) {
                NSString *value = ML_STRING_FORMAT(_headerParams[key]);
                [webRequest setValue:value forHTTPHeaderField:key];
            }
            [_wkWebView loadRequest:webRequest];
        }
    }
}

- (void)loadLocalHtml:(NSString *)fileName
{
    if ([ML_STRING_FORMAT(fileName) length] == 0) {
        return;
    }
    NSString *fullFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSError* error = nil;
    NSURL* fileURL = [NSURL fileURLWithPath:fullFilePath];
    NSString* html = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&error];
    [_wkWebView loadHTMLString: html baseURL: fileURL];
}

#pragma mark - WKWebview
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *urlString = navigationAction.request.URL.absoluteString;
    
    if (![urlString hasPrefix:@"http"] || [urlString hasPrefix:@"https://itunes.apple.com"]) {
        if ([urlString hasSuffix:@".html"]) {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
        else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            });
            decisionHandler(WKNavigationActionPolicyCancel);
        }
        else{
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }
    else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    [webView reload];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self startLoading];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    [self stopLoding];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self stopLoding];
    if(error.code == NSURLErrorCancelled)  {
        return;
    }
    if (error.code == NSURLErrorUnsupportedURL) {
        return;
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self stopLoding];
    if (!self.webTitle) {
        self.navBar.navTitle = webView.title;
    }
}

#pragma -mark WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    [self jsCallNativeAction:ML_STRING_FORMAT(message.name) body:message.body];
}

#pragma -mark native-call-js
- (void)handleJS:(NSString *)js wkWebView:(WKWebView *)web completionHandler:(nonnull void (^)(id _Nullable response))completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [web evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            completion(response);
        }];
    });
}

- (void)handleCallback:(NSString *)callback json:(NSString *)json
{
    NSString *js = [NSString stringWithFormat:@"%@('%@')",callback,json];
    [self handleJS:js wkWebView:self.wkWebView completionHandler:^(id  _Nullable response) {
    }];
}

#pragma mark - 加载JS处理
- (void)jsCallNativeAction:(NSString *)name body:(id)body
{
    NSLog(@"%@----%@",name,body);
#pragma mark - web容器
    if ([name isEqualToString:@"AIOpenWebPage"]) {
        NSString *url = ML_STRING_FORMAT(body[@"url"]);
        id param = body[@"params"];
        if (!param || [param isKindOfClass:[NSString class]]) {
            param = @{};
        }
        [self pushWebPage:url param:param];
    }
    else if ([name isEqualToString:@"AIWebGoback"]) {
        [self goWebHistory];
    }
    else if ([name isEqualToString:@"AIWebRefresh"]) {
        [self loadUrl];
    }
    else if ([name isEqualToString:@"AIWebClose"]) {
        [self popController];
    }
    else if ([name isEqualToString:@"AIGetParams"]) {
        [self handleCallback:@"AIGetParamsCallback" json:[self dicToString:self.params]];
    }
    else{
        
    }
}

#pragma -mark js-call-native 方法
- (void)pushWebPage:(NSString *)url param:(id )param
{
    MLWebController *controller = [MLWebController new];
    controller.url = url;
    controller.userAgent = self.userAgent;
    controller.headerParams = self.headerParams;
    controller.jsNamesArray = jsArray;
    controller.wkWeb = _wkWebView;
    controller.params = param;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goWebHistory{
    if ([_wkWebView canGoBack]) {
        [_wkWebView goBack];
    }
    else {
        [self popController];
    }
}

- (void)popController
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma -mark private
- (NSString *)dicToString:(NSDictionary *)dict
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (json.length>0) {
        json = [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        json = [json stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        json = [json stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        json = [json stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return json;
}

- (NSString *)arrToString:(NSArray *)arr{
    NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return json;
}

@end
