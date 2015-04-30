//
//  KPLoginViewController.h
//  YPanExample
//
//  Created by shirley on 15/4/30.
//  Copyright (c) 2015年 yangjie. All rights reserved.
//

#import <UIKit/UIKit.h>

// 获取完成的Block
typedef void (^ loginedBlock)(NSString *oauth_verifier);

@interface KPLoginViewController : UIViewController <UIWebViewDelegate> {
 @private
    UIWebView *webLoginView;
    NSString *loginURL;
    loginedBlock lBlock;
}

- (void)openLogin:(NSString *)oauth_token finish:(loginedBlock)block;

@end
