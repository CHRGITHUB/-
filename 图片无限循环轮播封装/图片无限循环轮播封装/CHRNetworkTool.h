//
//  CHRNetworkTool.h
//
//  Created by  on 15/6/14.
//  Copyright © 2015年 chenhongrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface CHRNetworkTool : AFHTTPSessionManager

+ (instancetype)sharedNetworkTool;

@end
