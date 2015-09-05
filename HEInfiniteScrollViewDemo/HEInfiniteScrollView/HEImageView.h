//
//  HEImageView.h
//  HEInfiniteScrollView
//
//  Created by 贺瑞 on 15/5/1.
//  Copyright (c) 2015年 herui. All rights reserved.


/** 目前发现的问题点
 
 不够灵活，每一页的样式给固定死了，使用起来略麻烦；可否收集常见样式，将之汇总并以更简洁的方式供之使用？
 数据以模型的形式传递，可提高扩展性；
 
 */


#import <UIKit/UIKit.h>

@interface HEImageView : UIImageView

// 取值可以是 UIImage、NSURL、UIView
@property (nonatomic, strong) id contentObj;

@property (nonatomic, strong) UIImage *placeholder;

@end
