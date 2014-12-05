//
//  LoopScrollView.m
//  LoopScrollViewDemo
//
//  Created by wangtian on 14-12-3.
//  Copyright (c) 2014年 wangtian. All rights reserved.
//

#import "LoopScrollView.h"
#define NSNumberValue(Integer) [NSNumber numberWithInteger:Integer]
#define Width(view) CGRectGetWidth(view.frame)
#define Height(view)  CGRectGetHeight(view.frame)
@implementation LoopScrollView

+ (LoopScrollView *)loopScrllViewWithImageArray:(NSArray *)imageArray frame:(CGRect)frame
{
    LoopScrollView *loop = [[LoopScrollView alloc] initWithFrame:frame];
    loop.imageArray = [NSMutableArray arrayWithArray:imageArray];
    loop.contentArray = [[NSMutableArray alloc] init];
    [loop configueScrollView];
    return loop;
}

#pragma mark - 设置scrollview
- (void)configueScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:self.scrollView];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(3 * Width(self), 0);
    self.scrollView.contentOffset = CGPointMake(Width(self),0);
    self.currentIndex = 0;
    [self setScrollViewContent];
}

#pragma mark - 设置pageControl
- (void)configuePageControlNormalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor  marginWithBottom:(CGFloat)bottomMargin
{
    self.pageControl = [UIPageControl alloc];
    CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:self.imageArray.count];
    self.pageControl = [self.pageControl initWithFrame:CGRectMake(0, 0, pageControlSize.width, pageControlSize.height)];
    self.pageControl.numberOfPages = self.imageArray.count;
    self.pageControl.currentPageIndicatorTintColor = selectColor;
    self.pageControl.pageIndicatorTintColor = normalColor;
    CGPoint pageControlCenter = self.pageControl.center;
    pageControlCenter.x = Width(self) / 2;
    pageControlCenter.y = Height(self) - bottomMargin - Height(self.pageControl) / 2;
    self.pageControl.center = pageControlCenter;
    [self addSubview:self.pageControl];
}

#pragma mark - 设置titleLabel
//TODO: 应该添加方便设置label位置的方法 类pageControl
- (void)setTitleWithTitleArray:(NSArray *)titleArray Frame:(CGRect)frame textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize
{
    self.titleArray = [NSMutableArray arrayWithArray:titleArray];
    self.titleLabelArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < 3; i++){
    
        UIButton *btn = [self.contentArray objectAtIndex:i];
        [btn addTarget:self action:@selector(clickView:) forControlEvents:(UIControlEventTouchUpInside)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
        [titleLabel setTextColor:textColor];
        titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [self.titleLabelArray addObject:titleLabel];
        [btn addSubview:titleLabel];
    }
    NSInteger firstIndex = [self validIndex:-1];
    NSMutableArray *contentTitleArray = [self getNowTitleArrayWithIndexArray:@[NSNumberValue(firstIndex),@0,@1]];
    [self setContentTitleWithArray:contentTitleArray];
}

- (NSMutableArray *)getNowImageArrayWithIndexArray:(NSArray *)array
{
    NSMutableArray *contentImageArray = [[NSMutableArray alloc] init];
    [contentImageArray addObject:[self.imageArray objectAtIndex:[[array objectAtIndex:0] integerValue]]];
    [contentImageArray addObject:[self.imageArray objectAtIndex:[[array objectAtIndex:1] integerValue]]];
    [contentImageArray addObject:[self.imageArray objectAtIndex:[[array objectAtIndex:2] integerValue]]];
    return contentImageArray;
}

- (NSMutableArray *)getNowTitleArrayWithIndexArray:(NSArray *)array
{
    NSMutableArray *contentTitleArray = [[NSMutableArray alloc] init];
    [contentTitleArray addObject:[self.titleArray objectAtIndex:[[array objectAtIndex:0] integerValue]]];
    [contentTitleArray addObject:[self.titleArray objectAtIndex:[[array objectAtIndex:1] integerValue]]];
    [contentTitleArray addObject:[self.titleArray objectAtIndex:[[array objectAtIndex:2] integerValue]]];
    return contentTitleArray;
}

- (void)setScrollViewContent
{
    CGFloat selfWidth = CGRectGetWidth(self.frame);
    CGFloat selfHeight = CGRectGetHeight(self.frame);
    NSInteger firstIndex = [self validIndex:-1];
    NSMutableArray *contentImageArray = [self getNowImageArrayWithIndexArray:@[NSNumberValue(firstIndex),@0,@1]];
    for (int i = 0; i < 3; i++) {
        
        UIButton *view = [[UIButton alloc] init];
        view.adjustsImageWhenHighlighted = NO;
        view.tag = i;
        view.frame = CGRectMake(i * selfWidth, 0, selfWidth, selfHeight);
        [self.contentArray addObject:view];
        [self.scrollView addSubview:view];
    }
    [self setContentViewImageWithArray:contentImageArray];
}

- (NSString *)imagePathWithImageName:(NSString *)imageName
{
    NSString *ext = [imageName pathExtension];
    NSString *prefix = [imageName stringByDeletingPathExtension];
    return [[NSBundle mainBundle] pathForResource:prefix ofType:ext];
}

- (void)setContentViewImageWithArray:(NSMutableArray *)imageArray
{
    for(int i = 0; i < 3; i++){
    
        UIButton *btn = [self.contentArray objectAtIndex:i];
        NSString *imagePath = [self imagePathWithImageName:[imageArray objectAtIndex:i]];
        [btn setImage:[UIImage imageWithContentsOfFile:imagePath] forState:(UIControlStateNormal)];
    }
}

- (void)setContentTitleWithArray:(NSMutableArray *)titleArray
{
    for(int i = 0; i < 3; i++){
        
        UILabel *label = [self.titleLabelArray objectAtIndex:i];
        label.text = [titleArray objectAtIndex:i];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    if (x == 2 * Width(self)) {
        
        [self scrollToNextPage:YES];
    }
    else if (x == 0){
    
        [self scrollToNextPage:NO];
    }
}

- (NSInteger)validIndex:(NSInteger)index
{
     NSInteger imageNumbers = self.imageArray.count;
    if (index < 0) {
        
        index = imageNumbers - 1;
    }
    else if (index > imageNumbers - 1){
    
        index = 0;
    }
    return index;
}

- (void)scrollToNextPage:(BOOL)next
{
    NSInteger firstIndex,secondIndex,thridIndex;
    if (next) {
        
        firstIndex = self.currentIndex;
        secondIndex = [self validIndex:self.currentIndex + 1];
        thridIndex = [self validIndex:secondIndex + 1];
    }
    else{
    
        thridIndex = self.currentIndex;
        secondIndex = [self validIndex:self.currentIndex - 1];
        firstIndex = [self validIndex:secondIndex - 1];
    }
    NSArray *nowIndexArray = [NSArray arrayWithObjects:NSNumberValue(firstIndex),NSNumberValue(secondIndex),NSNumberValue(thridIndex), nil];
    
    NSMutableArray *nowImageArray = [self getNowImageArrayWithIndexArray:nowIndexArray];
    [self setContentViewImageWithArray:nowImageArray];
    if (self.titleArray != nil) {
        
        NSMutableArray *nowTitleArray = [self getNowTitleArrayWithIndexArray:nowIndexArray];
        [self setContentTitleWithArray:nowTitleArray];
    }
    self.currentIndex = secondIndex;
    self.pageControl.currentPage = self.currentIndex;
    self.scrollView.contentOffset = CGPointMake( Width(self),0);
}

- (void)beginAutoScroll
{
    [self.scrollView setContentOffset:CGPointMake(2 * Width(self), 0) animated:YES];
}

- (void)startAutoScrollWithDuration:(CGFloat)duration
{
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(beginAutoScroll) userInfo:nil repeats:YES];
}

- (void)stopAutoScroll
{
    [self.autoScrollTimer invalidate];
    self.autoScrollTimer = nil;
}

- (void)clickView:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(clickWithIndex:)]) {
        
        [self.delegate clickWithIndex:self.currentIndex];
    }
}

- (void)setPageControlPositionTop:(CGFloat)top left:(CGFloat)left
{
    CGRect pageControlFrame = self.pageControl.frame;
    pageControlFrame.origin.x = left;
    pageControlFrame.origin.y = top;
    self.pageControl.frame = pageControlFrame;
}

- (void)setPageControlPositionBottom:(CGFloat)bottom right:(CGFloat)right
{
    CGRect pageControlFrame = self.pageControl.frame;
    pageControlFrame.origin.x = Width(self) - right - Width(self.pageControl);
    pageControlFrame.origin.y = Height(self) - bottom - Height(self.pageControl);
    self.pageControl.frame = pageControlFrame;
}

- (void)dealloc
{
    NSLog(@"loop scrollView被释放了");
}

@end
