//
//  HEImageView.h
//  HEInfiniteScrollView
//
//  Created by 贺瑞 on 15/5/1.
//  Copyright (c) 2015年 herui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HEImageView : UIImageView

// UIImage or NSURL
@property (nonatomic, strong) id contentObj;

@property (nonatomic, strong) UIImage *placeholder;

@end
