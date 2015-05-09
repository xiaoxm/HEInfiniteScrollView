//
//  HEInfiniteScrollView.h
//  HEInfiniteScrollView
//
//  Created by 贺瑞 on 15/5/1.
//  Copyright (c) 2015年 herui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HEInfiniteScrollView;

#define kTimeInterval 2.5       //自动翻页时间间隔
#define kAnimateDuration 0.5    //翻页动效持续时间


typedef NS_ENUM(NSInteger, HESwitchType){
    kHESwitchTypeLandscape = 0, //横向(default)
//    kHESwitchTypePortrait,      //纵向
    kHESwitchTypeFadeOut,       //淡出
};

typedef NS_ENUM(NSInteger, HEPageControlContentMode){
    kHEPageControlContentModeBottomRight = 0,   //右下角(default)
    kHEPageControlContentModeBottomLeft,        //左下角
    kHEPageControlContentModeBottomCenter,      //底部居中
};


@protocol HEInfiniteScrollViewDelegate <NSObject>

@optional
//点击图片时调用
- (void)infiniteScrollView:(HEInfiniteScrollView *)infiniteScrollView ItemOnclick:(NSUInteger)index;
//翻页完成时调用
- (void)infiniteScrollView:(HEInfiniteScrollView *)infiniteScrollView DidFlipOver:(NSUInteger)pageNum;

@end

@interface HEInfiniteScrollView : UIView

@property (nonatomic, assign) HESwitchType switchType;//切换效果

@property (nonatomic, assign) HEPageControlContentMode pageControlContentMode;
@property (nonatomic, assign) UIOffset pageControlOffset;//default is (10,5)

@property (nonatomic, weak) id<HEInfiniteScrollViewDelegate> delegate;

// UIImage or NSURL
- (void)setContentObjs:(NSArray *)contentObjs Placeholder:(UIImage *)placeholder;

@end
