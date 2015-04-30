//
//  KPAuthFetcher.m
//  YPanExample
//
//  Created by shirley on 15/4/29.
//  Copyright (c) 2015年 yangjie. All rights reserved.
//

#import "KPAuthFetcher.h"

#import "Base64.h"
#import "NSString+Crypto.h"
#import "NSString+URLEncode.h"

#define requestTokenURL @"https://openapi.kuaipan.cn/open/requestToken"

#define accessTokenURL @"https://openapi.kuaipan.cn/open/accessToken"

@implementation KPAuthFetcher

+ (void)fetchRequestTokenConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret finish:(finishRequestTokenBlock)block {
    
    NSString *oauth_signature_key = [NSString stringWithFormat:@"%@&", consumerSecret];
    
    NSLog(@"oauth_signature_key --> %@", oauth_signature_key);
    
    NSString *origin_str = @"GET&";
    
    NSString *base_uri = requestTokenURL;
    origin_str = [origin_str stringByAppendingString:[base_uri URLEncode]];
    origin_str = [origin_str stringByAppendingString:@"&"];
    
    NSString *paramStr = @"";
    
    NSString *onceStr = [AuthTool authnonce];
    NSString *timestamp = [AuthTool timestamp];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@=%@&",@"oauth_consumer_key", [consumerKey URLEncode]];
    paramStr = [paramStr stringByAppendingString:[tempStr URLEncode]];
    
    tempStr = [NSString stringWithFormat:@"oauth_nonce=%@&", onceStr];
    paramStr = [paramStr stringByAppendingString:[tempStr URLEncode]];
    
    tempStr = [NSString stringWithFormat:@"oauth_signature_method=%@&", @"HMAC-SHA1"];
    paramStr = [paramStr stringByAppendingString:[tempStr URLEncode]];
    
    tempStr = [NSString stringWithFormat:@"oauth_timestamp=%@&", timestamp];
    paramStr = [paramStr stringByAppendingString:[tempStr URLEncode]];
    
    tempStr = @"oauth_version=1.0";
    paramStr = [paramStr stringByAppendingString:[tempStr URLEncode]];
    
    paramStr = [origin_str stringByAppendingString:paramStr];
    
    NSLog(@"paramStr -> %@", paramStr);
    
    NSString *oauth_signature = [paramStr HMACSHA1WithSecret:oauth_signature_key];
    
    NSLog(@"oauth_sinature -> %@", [oauth_signature URLEncode]);
    
    NSString *url = [NSString stringWithFormat:@"%@?oauth_nonce=%@&oauth_timestamp=%@&oauth_consumer_key=%@&oauth_signature_method=HMAC-SHA1&oauth_version=1.0&oauth_signature=%@", requestTokenURL, onceStr, timestamp, consumerKey, [oauth_signature URLEncode]];

    
    NSLog(@"fetchRequestToken url -> %@", url);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dict -> %@", dict.description);
        
        if (dict) {
            
            NSString *oauth_token = [dict objectForKey:@"oauth_token"];
            NSString *oauth_token_secret = [dict objectForKey:@"oauth_token_secret"];
            
            block(YES, oauth_token, oauth_token_secret);
        } else {
            
            block(NO, nil, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error -> %@", error);
        
        block(NO, nil, nil);
    }];
}

+ (void)fetchAccessTokenConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret oauthToken:(NSString *)oauth_token oauthTokenSecret:(NSString *)oauth_token_secret oauthVerifier:(NSString *)oauth_verifier finish:(finishAccessToken)block {
    
    NSString *oauth_signature_key = [NSString stringWithFormat:@"%@&%@", consumerSecret, oauth_token_secret];
    
    NSLog(@"oauth_signature_key --> %@", oauth_signature_key);
    
    NSString *origin_str = @"GET&";
    
    NSString *base_uri = accessTokenURL;
    origin_str = [origin_str stringByAppendingString:[base_uri URLEncode]];
    origin_str = [origin_str stringByAppendingString:@"&"];
    
    NSString *paramStr = @"";
    
    NSString *onceStr = [AuthTool authnonce];
    NSString *timestamp = [AuthTool timestamp];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@=%@&",@"oauth_consumer_key", [consumerKey URLEncode]];
    paramStr = [paramStr stringByAppendingString:[tempStr URLEncode]];
    
    tempStr = [NSString stringWithFormat:@"oauth_nonce=%@&", onceStr];
    paramStr = [paramStr stringByAppendingString:[tempStr URLEncode]];
    
    tempStr = [NSString stringWithFormat:@"oauth_signature_method=%@&", @"HMAC-SHA1"];
    paramStr = [paramStr stringByAppendingString:[tempStr URLEncode]];
    
    tempStr = [NSString stringWithFormat:@"oauth_timestamp=%@&", timestamp];
    paramStr = [paramStr stringByAppendingString:[tempStr URLEncode]];
    
    tempStr = [NSString stringWithFormat:@"oauth_token=%@&", oauth_token];
    paramStr = [paramStr stringByAppendingString:[tempStr URLEncode]];
    
    tempStr = [NSString stringWithFormat:@"oauth_verifier=%@&", oauth_verifier];
    paramStr = [paramStr stringByAppendingString:[tempStr URLEncode]];
    
    tempStr = @"oauth_version=1.0";
    paramStr = [paramStr stringByAppendingString:[tempStr URLEncode]];
    
    paramStr = [origin_str stringByAppendingString:paramStr];
    
    NSLog(@"paramStr -> %@", paramStr);
    
    NSString *oauth_signature = [paramStr HMACSHA1WithSecret:oauth_signature_key];
    
    NSLog(@"oauth_sinature -> %@", [oauth_signature URLEncode]);
    
    NSString *url = [NSString stringWithFormat:@"%@?oauth_nonce=%@&oauth_timestamp=%@&oauth_consumer_key=%@&oauth_signature_method=HMAC-SHA1&oauth_version=1.0&oauth_signature=%@&oauth_token=%@&oauth_verifier=%@", accessTokenURL, onceStr, timestamp, consumerKey, [oauth_signature URLEncode], oauth_token, oauth_verifier];
    
    
    NSLog(@"fetchRequestToken url -> %@", url);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dict -> %@", dict.description);
        
        if (dict) {
            
            NSString *oauth_token = [dict objectForKey:@"oauth_token"];
            NSString *oauth_token_secret = [dict objectForKey:@"oauth_token_secret"];
            NSString *user_id = [dict objectForKey:@"user_id"];
            block(YES, oauth_token, oauth_token_secret, user_id);
        } else {
            
            block(NO, nil, nil, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error -> %@", error);
        
        block(NO, nil, nil, nil);
    }];
}
@end


























