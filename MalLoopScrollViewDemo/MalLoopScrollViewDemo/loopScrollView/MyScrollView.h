//
//  MyScrollView.h
//  MalLoopScrollViewDemo
//
//  Created by wangtian on 15/7/28.
//  Copyright (c) 2015年 wangtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyScrollView : UIScrollView<UIGestureRecognizerDelegate>

@property (nonatomic, assign) NSInteger nowIndex;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) BOOL isLoop;

@end
