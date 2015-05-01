//
//  HEInfiniteScrollView.h
//  HEInfiniteScrollView
//
//  Created by 贺瑞 on 15/5/1.
//  Copyright (c) 2015年 herui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HEInfiniteScrollView;

@protocol HEInfiniteScrollViewDelegate <NSObject>

@optional
//点击图片时调用
- (void)infiniteScrollView:(HEInfiniteScrollView *)infiniteScrollView ItemOnclick:(NSUInteger)index;
@end

@interface HEInfiniteScrollView : UIView

//
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, assign) UIOffset pageControlOffset;//default (10,-5)

@property (nonatomic, weak) id<HEInfiniteScrollViewDelegate> delegate;

// UIImage or NSURL
- (void)setContentObjs:(NSArray *)contentObjs Placeholder:(UIImage *)placeholder;

@end
