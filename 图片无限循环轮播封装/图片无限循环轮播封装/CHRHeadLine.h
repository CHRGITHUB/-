//
//  CHRHeadLine.h
//
//  Created by  on 15/6/14.
//  Copyright © 2015年 chenhongorng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHRHeadLine : NSObject
/**
 *  新闻标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  新闻图片
 */
@property (nonatomic, copy) NSString *imgsrc;

+ (instancetype)headLineWithDict:(NSDictionary *)dict;

/**
 *
 *  加载新闻头条数据
 *
 *  @param success 成功回调
 *  @param failed  失败回调
 */
+ (void)loadHeadLineSuccess:(void (^)(NSArray *headlines))success failed:(void (^)(NSError *error))failed;

@end
