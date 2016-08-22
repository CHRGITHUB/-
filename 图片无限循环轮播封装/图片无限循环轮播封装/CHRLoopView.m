//
//
//  CHRLoopView.m
//
//  Created by  on 15/6/14.
//  Copyright © 2015年 chenhongrong. All rights reserved.
//

#import "CHRLoopView.h"
#import "CHRLoopViewCell.h"
#import "CHRLoopViewLayout.h"
#import "CHRWeakTimerTargetObj.h"


@interface CHRLoopView() <UICollectionViewDataSource,UICollectionViewDelegate>
/**
 *  轮播控件
 */
@property (nonatomic, strong) UICollectionView *collectionView;
/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  分页控件
 */
@property (nonatomic, strong) UIPageControl *pageControl;
/**
 *  图片数组
 */
@property (nonatomic, strong) NSArray *URLs;
/**
 *  标题数组
 */
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, copy) void (^didSelected)(NSInteger index);
/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CHRLoopView

/**
 *  根据图片数组和标题数组初始化图片轮播器
 *
 *  @param URLs   图片数组
 *  @param titles 标题数组
 *
 *  @return 图片轮播器
 */
- (instancetype)initWithURLs:(NSArray <NSString *> *)URLs titles:(NSArray <NSString *> *)titles didSelected:(void (^)(NSInteger))didSelected{
    if (self = [super init]) {
        // 记录属性
        self.URLs = URLs;
        self.titles = titles;
        self.didSelected = didSelected;
        
        // 设置总页数
        self.pageControl.numberOfPages = URLs.count;
        self.titleLabel.text = titles[0];
        
        // 滚动到指定的item
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.URLs.count > 1) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.URLs.count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
                
                // 开启定时器
                [self addTimer];
            }
        });
        
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

/**
 *  初始化子控件
 */
- (void)setup {
    // 创建UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[CHRLoopViewLayout alloc] init]];
    // 注册cell
    [collectionView registerClass:[CHRLoopViewCell class] forCellWithReuseIdentifier:@"loopView"];
    collectionView.backgroundColor = [UIColor whiteColor];
    // 设置数据源
    collectionView.dataSource = self;
    // 设置代理方法
    collectionView.delegate = self;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    // 创建标题标签:UILabel
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    // 分页控件:UIPageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    // 设置只有一个点时不显示分页控件
    pageControl.hidesForSinglePage = YES;
    // 设置其他点颜色
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    // 设置当前点的颜色
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
}

#pragma mark - 定时器相关方法
/**
 *  添加定时器
 */
- (void)addTimer {
    if (!self.enableTimer) return;
    if (self.URLs.count <= 1) return;
    if (self.timer) return;
    // 创建定时器
    self.timer = [CHRWeakTimerTargetObj scheduledTimerWithTimeInterval:self.timerInterval target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    // 添加到运行循环
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  移除定时器
 */
- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}
/**
 *  定时器回调方法
 */
- (void)nextImage {
    // 获得偏移量
    CGFloat offsetX = self.collectionView.contentOffset.x;
    // 获得宽度
    CGFloat width = self.collectionView.bounds.size.width;
    // 计算当前显示的页号
    NSInteger page = offsetX / width;
    // 修改偏移量
    [self.collectionView setContentOffset:CGPointMake((page + 1) * width, 0) animated:YES];
}

#pragma mark - UICollectionViewDataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.URLs.count > 1 ? self.URLs.count * 3: self.URLs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 从缓存池获得cell
    CHRLoopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"loopView" forIndexPath:indexPath];
    // 传递数据
    cell.URL = [NSURL URLWithString:self.URLs[indexPath.item % self.URLs.count]];
    return cell;
}

#pragma mark - UICollectionViewDelegate 代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelected) {
        self.didSelected(indexPath.item % self.URLs.count);
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 获得偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    // 获得宽度
    CGFloat width = scrollView.bounds.size.width;
    // 计算当前显示的页号
    NSInteger page = offsetX / width;
    
    if (page == 0 || page == [self.collectionView numberOfItemsInSection:0] - 1) { // 第0页
        page = (page == 0) ? self.URLs.count:self.URLs.count - 1;
        // 修改collectionView的偏移量
        self.collectionView.contentOffset = CGPointMake(page * width, 0);
    }
    // 设置标题和页号
    self.pageControl.currentPage = page % self.URLs.count;
    self.titleLabel.text = self.titles[self.pageControl.currentPage];
    
    // 添加定时器
    [self addTimer];
}

/**
 *  当滚动动画结束时调用 (通过定时器滚动,并非手动拖拽)
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

/**
 *  当用户开始拖拽时调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 移除定时器
    [self removeTimer];
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 设置collectionView
    self.collectionView.frame = self.bounds;
    
    CGFloat pageW = [self.pageControl sizeForNumberOfPages:self.URLs.count].width;
    
       CGFloat titleH = 30;
       CGFloat marginX = 10;
    // 设置标题的frame
      CGFloat titleX = marginX;
       CGFloat titelY = self.bounds.size.height - titleH;
      CGFloat titleW = self.bounds.size.width - 3 * marginX - pageW;
    self.titleLabel.frame = CGRectMake(titleX, titelY, titleW, titleH);
    
    // 设置pageControl的frame
    CGFloat pageH = titleH;
    CGFloat pageX = self.bounds.size.width - pageW - marginX;
    CGFloat pageY = titelY;
    
    self.pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);
}

- (void)dealloc {
    [self removeTimer];
}
@end
