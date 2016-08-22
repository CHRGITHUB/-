//
//  ViewController.m
//  图片无限循环轮播封装
//
//  Created by 陈红荣 on 15/6/19.
//  Copyright © 2015年 chenHongRong. All rights reserved.
//

#import "ViewController.h"
#import "CHRLoopView.h"
#import "CHRHeadLine.h"


@interface ViewController ()
/**
 *  新闻头条数组
 */
@property (nonatomic, strong) NSArray *headlines;
/**
 *  图片轮播器
 */
@property (nonatomic, strong) CHRLoopView *loopView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获得新闻头条数组
    [CHRHeadLine loadHeadLineSuccess:^(NSArray *headlines) {
        // 记录数组
        self.headlines = headlines;
        // 显示界面
        [self.view addSubview:self.loopView];
        
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark - 懒加载图片轮播器
-(CHRLoopView *)loopView {
    if (_loopView == nil) {
        // 获得新闻图片数组
        NSArray *images = [self.headlines valueForKeyPath:@"imgsrc"];
        // 获得标题数组
        NSArray *titles = [self.headlines valueForKeyPath:@"title"];
        _loopView = [[CHRLoopView alloc] initWithURLs:images titles:titles didSelected:^(NSInteger index) {
            NSLog(@"点击了 第%zd ✌️",index);
        }];
        //设置定时器 轮播时间
        _loopView.timerInterval = 5;
        //设置定时器是否开启
        _loopView.enableTimer = YES;
        // 设置frame
        _loopView.frame = CGRectMake(0,20, self.view.frame.size.width, 260);
    }
    return _loopView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
