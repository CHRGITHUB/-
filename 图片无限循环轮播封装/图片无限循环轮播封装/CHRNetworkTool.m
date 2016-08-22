//
//  CHRNetworkTool.m
//
//  Created by  on 15/6/14.
//  Copyright © 2015年 chenhongrong. All rights reserved.
//


#import "CHRNetworkTool.h"

@implementation CHRNetworkTool
+ (instancetype)sharedNetworkTool {
    static id instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        http://c.m.163.com/nc/ad/headline/0-4.html
        
        NSURL *baseURL = [NSURL URLWithString:@"http://c.m.163.com/nc/"];
        instance = [[self alloc] initWithBaseURL:baseURL];
    });
    
    return instance;
}
@end
