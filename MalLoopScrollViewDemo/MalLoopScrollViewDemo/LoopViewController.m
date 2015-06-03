//
//  LoopViewController.m
//  LoopScrollViewDemo
//
//  Created by wangtian on 14-12-4.
//  Copyright (c) 2014年 wangtian. All rights reserved.
//

#import "LoopViewController.h"
#import "LoopScrollView.h"
@interface LoopViewController ()<LoopScrollViewDelegate>
{
    LoopScrollView *_loop;
}
@end

@implementation LoopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUpLoopScrollView];
}

- (void)setUpLoopScrollView
{
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"newses" ofType:@"plist"];
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:filePath];
    for(NSDictionary *dic in dataArray){
        
        [imageArray addObject:[dic objectForKey:@"icon"]];
        [titleArray addObject:[dic objectForKey:@"title"]];
    }
    CGFloat loopViewWidth = MainScreen_Size.width;
    CGFloat loopViewHeight = MainScreen_Size.width * (150.0 / 320);
    _loop = [LoopScrollView loopScrllViewWithImageArray:imageArray frame:CGRectMake(0, 64, loopViewWidth, loopViewHeight) setImageBlock:^(UIButton *btn, NSString *imageName) {
        
        //自定义设置图片方法   //如果是本地图片此参数可置为nil
        //主要用来加载网络图片  
        [btn setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
        
    }];
    [_loop setTitleWithTitleArray:titleArray Frame:CGRectMake(5, 5, 300, 20) textColor:[UIColor redColor] fontSize:16];//如果不需要显示文字可屏蔽
    _loop.delegate = self;
    [_loop configuePageControlNormalColor:[UIColor whiteColor] selectColor:[UIColor orangeColor]marginWithBottom:0];//如果不需要pageControl可屏蔽 //marginWithBottom距离下边界的距离
   
    [_loop setPageControlPositionBottom:-10 right:10];//设置pageControl的位置 //pageControl默认居中
    
    [self.view addSubview:_loop];
    _loop.isLoop = NO;
    [_loop startAutoScrollWithInterval:3];
}

#pragma mark - 一定要调用  否则viewcontroller 无法被释放
- (void)viewWillDisappear:(BOOL)animated
{
    [_loop releaseSelf];
}

#pragma mark - 点击触发事件
- (void)clickWithIndex:(NSInteger)index
{
    NSLog(@"点击了第%ld张",(long)index + 1);
}

- (void)viewScrollToPage:(NSInteger)currentIndex
{
    NSLog(@"滑动到第%d张了",(int)currentIndex + 1);
}

- (void)dealloc
{
    NSLog(@"loop controller被释放了");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
