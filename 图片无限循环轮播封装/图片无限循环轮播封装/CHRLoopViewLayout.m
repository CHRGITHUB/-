//
//  CHRLoopViewLayout.m
//
//  Created by  on 15/6/14.
//  Copyright © 2015年 chenhongrong. All rights reserved.
//

#import "CHRLoopViewLayout.h"

@implementation CHRLoopViewLayout

/**
 *  准备布局时调用:只要来到该方法,collectionView的尺寸已经确定
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    // 设置item尺寸
    self.itemSize = self.collectionView.bounds.size;
    // 设置item之间的间距
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    // 设置滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 设置分页效果
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;

}


@end
