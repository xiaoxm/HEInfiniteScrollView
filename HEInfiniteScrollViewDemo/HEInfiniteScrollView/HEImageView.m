//
//  HEImageView.m
//  HEInfiniteScrollView
//
//  Created by 贺瑞 on 15/5/1.
//  Copyright (c) 2015年 herui. All rights reserved.
//

#import "HEImageView.h"
#import "UIImageView+WebCache.h"

@implementation HEImageView

- (void)setContentObj:(id)contentObj{
//    return;
    
    if([contentObj isKindOfClass:[UIImage class]]){
        self.image = contentObj;
        
    }else if([contentObj isKindOfClass:[NSURL class]]){
        [self sd_setImageWithURL:contentObj
                placeholderImage:_placeholder
                         options:SDWebImageRetryFailed | SDWebImageContinueInBackground];
    }
}

@end
