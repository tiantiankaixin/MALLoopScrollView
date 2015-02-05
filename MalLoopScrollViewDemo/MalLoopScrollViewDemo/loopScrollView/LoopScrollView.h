//
//  LoopScrollView.h
//  LoopScrollViewDemo
//
//  Created by wangtian on 14-12-3.
//  Copyright (c) 2014年 wangtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoopScrollViewDelegate <NSObject>

- (void)clickWithIndex:(NSInteger)index;

@end

#define MainScreen_Size [UIScreen mainScreen].bounds.size

typedef void(^SetImageBlock)(UIButton *btn,NSString *imageName);

@interface LoopScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic,strong) NSMutableArray *contentArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *autoScrollTimer;
@property (nonatomic, strong) NSMutableArray *titleLabelArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, weak) id<LoopScrollViewDelegate> delegate;
@property (nonatomic, copy) SetImageBlock setImageBlock;

+ (LoopScrollView *)loopScrllViewWithImageArray:(NSArray *)imageArray frame:(CGRect)frame setImageBlock:(void(^)(UIButton *btn,NSString *imageName))setImageBlock;

- (void)startAutoScrollWithInterval:(CGFloat)interval;
- (void)stopAutoScroll;

- (void)setTitleWithTitleArray:(NSArray *)titleArray Frame:(CGRect)frame textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize;

//bottomMargin 控件和下边界的距离  因为pageControl自身高度和呈现高度不一致，所以设置的y看起来会有偏差
- (void)configuePageControlNormalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor marginWithBottom:(CGFloat)bottomMargin;

//pageCntrol距离 上 右边界的距离
- (void)setPageControlPositionTop:(CGFloat)top left:(CGFloat)left;
- (void)setPageControlPositionBottom:(CGFloat)bottom right:(CGFloat)right;

//释放自己
- (void)releaseSelf;
@end
