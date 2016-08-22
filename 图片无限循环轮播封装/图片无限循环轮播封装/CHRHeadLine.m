//
//  CHRHeadLine.m
//
//  Created by  on 15/6/14.
//  Copyright © 2015年 chenhongorng. All rights reserved.
//

#import "CHRHeadLine.h"
#import "CHRNetworkTool.h"

@implementation CHRHeadLine
+ (instancetype)headLineWithDict:(NSDictionary *)dict {
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dict];
    
    return obj;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

/**
 *
 *  加载新闻头条数据
 *
 *  @param success 成功回调
 *  @param failed  失败回调
 */
+ (void)loadHeadLineSuccess:(void (^)(NSArray *headlines))success failed:(void (^)(NSError *error))failed {
    NSAssert(success !=nil, @"成功回调一定不能为nil");
    [[CHRNetworkTool sharedNetworkTool] GET:@"ad/headline/0-4.html" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary  *responseObject) {
//        NSLog(@"%@",responseObject);
        // 获得字典的第一个key
        NSString *rootKey =  responseObject.keyEnumerator.nextObject;
        // 获得头条新闻数组
        NSArray *headlineArray = responseObject[rootKey];
        
        NSMutableArray *headlines = [NSMutableArray array];
        // 遍历数组
        [headlineArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
           // 字典转模型
           CHRHeadLine *headline = [CHRHeadLine headLineWithDict:dict];
            // 将模型添加到数组中
           [headlines addObject:headline];
        }];
        // 完成回调
        success(headlines.copy);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failed) {
            failed(error);
        }
    }];
}
@end
