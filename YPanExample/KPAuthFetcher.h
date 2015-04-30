//
//  KPAuthFetcher.h
//  YPanExample
//
//  Created by shirley on 15/4/29.
//  Copyright (c) 2015年 yangjie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking.h>

#import "AuthTool.h"

// 获取临时Token Block
typedef void (^finishRequestTokenBlock)(BOOL isSucc, NSString *oauth_token, NSString *oauth_token_secret);

// 获取accessToken
typedef void (^finishAccessToken)(BOOL isSucc, NSString *oauth_token, NSString *oauth_token_secret, NSString *user_id);

@interface KPAuthFetcher : NSObject

+ (void)fetchRequestTokenConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret finish:(finishRequestTokenBlock)block;


+ (void)fetchAccessTokenConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret oauthToken:(NSString *)oauth_token oauthTokenSecret:(NSString *)oauth_token_secret oauthVerifier:(NSString *)oauth_verifier finish:(finishAccessToken)block;
@end
