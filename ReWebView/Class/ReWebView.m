//
//  ReWebView.m
//  ReWebView
//
//  Created by Paddy on 17/4/28.
//  Copyright © 2017年 Paddy. All rights reserved.
//

#import "ReWebView.h"

#ifndef __IOS_8_0_OR_LATER
#define __IOS_8_0_OR_LATER      ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#endif

#ifndef k_RE_WEB_VIEW_USE_WEBKIT
#define k_RE_WEB_VIEW_USE_WEBKIT    __IOS_8_0_OR_LATER
#endif

@interface ReWebView ()<WKUIDelegate,WKNavigationDelegate,UIWebViewDelegate>
@property (nonatomic,strong) WKWebView *wk_WebView;
@property (nonatomic,strong) UIWebView *ui_WebView;
@end

@implementation ReWebView

- (instancetype)init{
    if (self = [super init]) {
        [self customset];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self customset];
}

-(void)customset{
    if (k_RE_WEB_VIEW_USE_WEBKIT) {
        self.wk_WebView .UIDelegate  = self;
        self.wk_WebView.navigationDelegate = self;
    }
    else {
        self.ui_WebView.delegate = self;
    }
    self.opaque = NO;
}


#pragma mark - WKUIDelegate

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURLRequest *request = navigationAction.request;
    
    if (self.ReDelegate && [self.ReDelegate respondsToSelector:@selector(reWebView:shouldStartLoadWithRequest:navigationType:)]) {
        BOOL pass = [self.ReDelegate reWebView:self shouldStartLoadWithRequest:request navigationType:(UIWebViewNavigationType)navigationAction.navigationType];
        if (pass) {
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }
        else {
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (self.ReDelegate && [self.ReDelegate respondsToSelector:@selector(reWebViewDidStartLoad:)]) {
        [self.ReDelegate reWebViewDidStartLoad:self];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.ReDelegate && [self.ReDelegate respondsToSelector:@selector(reWebViewDidFinishLoad:)]) {
        [self.ReDelegate reWebViewDidFinishLoad:self];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (self.ReDelegate && [self.ReDelegate respondsToSelector:@selector(reWebView:didFailLoadWithError:)]) {
        [self.ReDelegate reWebView:self didFailLoadWithError:error];
    }
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (self.ReDelegate && [self.ReDelegate respondsToSelector:@selector(reWebView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.ReDelegate reWebView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    if (self.ReDelegate && [self.ReDelegate respondsToSelector:@selector(reWebViewDidStartLoad:)]) {
        [self.ReDelegate reWebViewDidStartLoad:self];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (self.ReDelegate && [self.ReDelegate respondsToSelector:@selector(reWebViewDidFinishLoad:)]) {
        [self.ReDelegate reWebViewDidFinishLoad:self];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (self.ReDelegate && [self.ReDelegate respondsToSelector:@selector(reWebView:didFailLoadWithError:)]) {
        [self.ReDelegate reWebView:self didFailLoadWithError:error];
    }
}


#pragma mark - WebView Method
- (void)loadRequest:(NSURLRequest *)request{
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    if (k_RE_WEB_VIEW_USE_WEBKIT) {
        [self.wk_WebView loadRequest:request];
    }
    else {
        [self.ui_WebView loadRequest:request];
    }
}

- (void)goBack {
    if (k_RE_WEB_VIEW_USE_WEBKIT) {
        [self.wk_WebView goBack];
    }
    else {
        [self.ui_WebView goBack];
    }
}

- (void)goForward {
    if (k_RE_WEB_VIEW_USE_WEBKIT) {
        [self.wk_WebView goForward];
    }
    else {
        [self.ui_WebView goForward];
    }
}

- (void)reload {
    if (k_RE_WEB_VIEW_USE_WEBKIT) {
        [self.wk_WebView reload];
    }
    else {
        [self.ui_WebView reload];
    }
}

- (void)stopLoading {
    if (k_RE_WEB_VIEW_USE_WEBKIT) {
        [self.wk_WebView stopLoading];
    }
    else {
        [self.ui_WebView stopLoading];
    }
}

- (void)stringByEvaluatingJavaScriptFromString:(NSString *)script completionHandler:(ReWebViewJSExecuteBlock)handler{
    if (k_RE_WEB_VIEW_USE_WEBKIT) {
        [self.wk_WebView evaluateJavaScript:script completionHandler:^(id _Nullable data, NSError * _Nullable error) {
            if (handler) {
                handler(data,error);
            }
        }];
    }
    else{
        NSString *string = [self.ui_WebView stringByEvaluatingJavaScriptFromString:script];
        if (handler) {
            handler(string,nil);
        }
    }
}

- (void)configWebViewLayoutConstraint:(UIView *)webView {
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *superV = webView.superview;
    [superV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webView)]];
    [superV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webView)]];
    [superV setNeedsLayout];
    [superV layoutIfNeeded];
}


#pragma mark - setters
- (void)setScalesPageToFit:(BOOL)scalesPageToFit{
    if (!k_RE_WEB_VIEW_USE_WEBKIT) {
        self.ui_WebView.scalesPageToFit = scalesPageToFit;
    }
}

#pragma mark - getters
- (NSString *)title {
    if (k_RE_WEB_VIEW_USE_WEBKIT) {
        return self.wk_WebView.title;
    }
    else {
        return [self.ui_WebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

- (WKWebView *)wk_WebView {
    if (!k_RE_WEB_VIEW_USE_WEBKIT) {
        NSAssert(NO, @"k_RE_WEB_VIEW_USE_WEBKIT");
        return nil;
    }
    if (!_wk_WebView) {
        _wk_WebView = [[WKWebView alloc] init];
        [self addSubview:_wk_WebView];
        [self configWebViewLayoutConstraint:_wk_WebView];
    }
    return _wk_WebView;
}

- (UIWebView *)ui_WebView {
    if (!_ui_WebView) {
        _ui_WebView = [[UIWebView alloc] init];
        [self addSubview:_ui_WebView];
        [self configWebViewLayoutConstraint:_ui_WebView];
    }
    return _ui_WebView;
}

- (UIScrollView *)scrollView {
    if (k_RE_WEB_VIEW_USE_WEBKIT) {
        return self.wk_WebView.scrollView;
    }
    else {
        return self.ui_WebView.scrollView;
    }
}

- (BOOL)canGoBack {
    if (k_RE_WEB_VIEW_USE_WEBKIT) {
        return self.wk_WebView.canGoBack;
    }
    else {
        return self.ui_WebView.canGoBack;
    }
}

- (NSURL *)URL {
    if (k_RE_WEB_VIEW_USE_WEBKIT) {
        return self.wk_WebView.URL;
    }
    else {
        return self.ui_WebView.request.URL;
    }
}

- (BOOL)canGoForward {
    if (k_RE_WEB_VIEW_USE_WEBKIT) {
        return self.wk_WebView.canGoForward;
    }
    else {
        return self.ui_WebView.canGoForward;
    }
}

- (BOOL)isLoading {
    if (k_RE_WEB_VIEW_USE_WEBKIT) {
        return self.wk_WebView.isLoading;
    }
    else {
        return self.ui_WebView.isLoading;
    }
}

- (BOOL)scalesPageToFit{
    if (k_RE_WEB_VIEW_USE_WEBKIT) {
        return NO;
    }
    else {
        return self.ui_WebView.scalesPageToFit;
    }
}

@end
