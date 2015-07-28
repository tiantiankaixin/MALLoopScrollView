//
//  MyScrollView.m
//  MalLoopScrollViewDemo
//
//  Created by wangtian on 15/7/28.
//  Copyright (c) 2015年 wangtian. All rights reserved.
//

#import "MyScrollView.h"

@implementation MyScrollView

 - (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.panGestureRecognizer.delegate = self;
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (!self.isLoop)
    {
        CGPoint ve = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
        if (ve.x > 0)
        {
            if (self.nowIndex == 0)
            {
                return NO;
            }
        }
        else if(self.nowIndex == self.pageCount - 1)
        {
            return NO;
        }
    }
    return YES;
}

@end
