//
//  ReWebView.h
//  ReWebView
//
//  Created by Paddy on 17/4/28.
//  Copyright © 2017年 Paddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@class ReWebView;

typedef void (^ReWebViewJSExecuteBlock)(id data, NSError *error);


@protocol ReWebViewDelegate <NSObject>

@optional
- (BOOL)reWebView:(ReWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)reWebViewDidStartLoad:(ReWebView *)webView;
- (void)reWebViewDidFinishLoad:(ReWebView *)webView;
- (void)reWebView:(ReWebView *)webView didFailLoadWithError:(NSError *)error;

@end


@interface ReWebView : UIView

@property (nonatomic,weak) id<ReWebViewDelegate> ReDelegate;
@property (nonatomic,strong,readonly) UIScrollView *scrollView;
@property (nonatomic,copy,readonly) NSString *title;
@property (nonatomic,assign,readonly) BOOL canGoBack;
@property (nonatomic,assign,readonly) BOOL canGoForward;
@property (nonatomic,assign,readonly) BOOL isLoading;
@property (nonatomic,strong,readonly) NSURL *URL;
@property (nonatomic,assign) BOOL scalesPageToFit;

@property (nonatomic,strong,readonly) WKWebView *wk_WebView;

- (void)loadRequest:(NSURLRequest *)request;
- (void)reload;
- (void)stopLoading;

- (void)goBack;
- (void)goForward;

- (void)stringByEvaluatingJavaScriptFromString:(NSString *)script completionHandler:(ReWebViewJSExecuteBlock)handler;

@end
