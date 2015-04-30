//
//  ViewController.m
//  YPanExample
//
//  Created by shirley on 15/4/29.
//  Copyright (c) 2015年 yangjie. All rights reserved.
//

#import "ViewController.h"

#import "KPAuthFetcher.h"

#import "KPLoginViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // 获取临时授权token https://openapi.kuaipan.cn/open/requestToken
    
    [KPAuthFetcher fetchRequestTokenConsumerKey:consumer_key consumerSecret:consumer_secret finish:^(BOOL isSucc, NSString *oauth_token, NSString *oauth_token_secret) {
        
        if (isSucc) {
            
            NSLog(@"oauth_token -> %@\n oauth_token_secret -> %@", oauth_token, oauth_token_secret);
            
            KPLoginViewController *loginViewController = [[KPLoginViewController alloc] initWithNibName:nil bundle:nil];
            [self presentViewController:loginViewController animated:YES completion:^{
                
                [loginViewController openLogin:oauth_token finish:^(NSString *oauth_verfier) {
                    
                    NSLog(@"logined succ -> %@", oauth_verfier);
                    
                    [KPAuthFetcher fetchAccessTokenConsumerKey:consumer_key consumerSecret:consumer_secret oauthToken:oauth_token oauthTokenSecret:oauth_token_secret oauthVerifier:oauth_verfier finish:^(BOOL isSucc, NSString *oauth_token, NSString *oauth_token_secret, NSString *user_id) {
                        
                        // 这个地方拿到的东西 就是真正访问的校验oauth_token oauth_token_secret
                        // 具体校验算法 看KPAuthFether两个API里面 参数顺序不能搞错就好了 
                    }];
                }];
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
