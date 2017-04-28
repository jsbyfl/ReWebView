//
//  ViewController.m
//  ReWebView
//
//  Created by Paddy on 17/4/28.
//  Copyright © 2017年 Paddy. All rights reserved.
//

#import "ViewController.h"
#import "ReWebView.h"

@interface ViewController ()<ReWebViewDelegate>

@property (weak, nonatomic) IBOutlet ReWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView.ReDelegate = self;
    
    NSString *string = @"https://www.baidu.com";
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}
- (IBAction)backBtnAct:(id)sender {
    if (self.webView.canGoBack) {
        if (self.webView.isLoading) {
            [self.webView stopLoading];
        }
        [self.webView goBack];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - ReWebViewDelegate
- (BOOL)reWebView:(ReWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)reWebViewDidStartLoad:(ReWebView *)webView
{
    
}
- (void)reWebViewDidFinishLoad:(ReWebView *)webView
{
    
}
- (void)reWebView:(ReWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

@end
