//
//  AuthTool.m
//  YPanExample
//
//  Created by shirley on 15/4/29.
//  Copyright (c) 2015年 yangjie. All rights reserved.
//

#import "AuthTool.h"

@implementation AuthTool

+ (NSString *)timestamp {
    
    return [NSString stringWithFormat:@"%lli", (long long)[[NSDate new] timeIntervalSince1970]];
}

+ (NSString *)authnonce {
    
    NSArray *seedsArr = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
    NSString *onceStr = @"";
    for (int i = 0; i < 8; i ++) {
        
        int randIndex = arc4random() % 32;
        onceStr = [onceStr stringByAppendingString:[seedsArr objectAtIndex:randIndex]];
    }
    
    return onceStr;
}

@end
