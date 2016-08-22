//
//  CHRWeakTimerTargetObj.h

//  Created by  on 15/6/14.
//  Copyright © 2015年 chenhongrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHRWeakTimerTargetObj : NSObject

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)time target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;
@end
