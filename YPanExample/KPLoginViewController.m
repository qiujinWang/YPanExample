//
//  KPLoginViewController.m
//  YPanExample
//
//  Created by shirley on 15/4/30.
//  Copyright (c) 2015年 yangjie. All rights reserved.
//

#import "KPLoginViewController.h"

#define authriseURL @"https://www.kuaipan.cn/api.php?ac=open&op=authorise&oauth_token="

@implementation KPLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    webLoginView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webLoginView.delegate = self;
    [self.view addSubview:webLoginView];
}

- (void)openLogin:(NSString *)oauth_token finish:(loginedBlock)block {
    
    lBlock = block;
    
    NSString *url = [NSString stringWithFormat:@"%@%@", authriseURL, oauth_token];
    loginURL = url;
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webLoginView loadRequest:req];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if (![webView.request.URL.absoluteString isEqualToString:loginURL]) {
    
        NSString  *html = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
    
        NSLog(@"web content -> %@", html);
        
        NSRange range = [html rangeOfString:@"<strong>"];
        if (range.location != NSNotFound) {
            
            NSString *auth_code = [html substringWithRange:NSMakeRange(range.location + range.length, 9)];
            
            NSLog(@"auth_code -> %@", auth_code);
            
            [self dismissViewControllerAnimated:YES completion:^{
                
                if (lBlock) {
                    lBlock(auth_code);
                }
            }];
        }
    }
}

@end
