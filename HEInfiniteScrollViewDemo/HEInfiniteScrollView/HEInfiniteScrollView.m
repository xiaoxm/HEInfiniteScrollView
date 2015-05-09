//
//  HEInfiniteScrollView.m
//  HEInfiniteScrollView
//
//  Created by 贺瑞 on 15/5/1.
//  Copyright (c) 2015年 herui. All rights reserved.
//

#import "HEInfiniteScrollView.h"
#import "HEImageView.h"


typedef NS_ENUM(NSInteger, HEOrientationDragging){
    kHEOrientationDraggingLeft = 0, //朝左(default)
    kHEOrientationDraggingRight,    //朝右
};


@interface HEInfiniteScrollView()<UIScrollViewDelegate>

//NSURL or UIImage
@property (nonatomic, strong) NSArray *contentObjs;

//承载imageView的scrollView
@property (nonatomic, weak) UIScrollView *scrollView;

//左中右三个imageView
@property (nonatomic, weak) HEImageView *centerView;
@property (nonatomic, weak) HEImageView *leftView;
@property (nonatomic, weak) HEImageView *rightView;

//当前页码
@property (nonatomic, assign) int currPage;

//用户拖动瞬间scrollView的contentOffset.x
@property (nonatomic, assign) CGFloat beginDragOffsetX;

//自动切换定时器
@property (nonatomic, strong) NSTimer *timer;

//是否正在滑动中
@property (nonatomic, assign) __block BOOL isScrolling;

//
@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation HEInfiniteScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    //scrollView 尺寸相关
    _scrollView.frame = self.bounds;
    
    CGFloat scrollViewW = _scrollView.frame.size.width;
//    CGFloat scrollViewH = _scrollView.frame.size.height;
    
    _scrollView.contentSize = CGSizeMake(3 * scrollViewW, 0);
    _scrollView.contentOffset = CGPointMake(scrollViewW, 0);
    
    
    [self layoutContetImageViews];
    
    [self layoutPageControl];
}

- (void)layoutContetImageViews{
    
    CGFloat scrollViewW = _scrollView.frame.size.width;
    CGFloat scrollViewH = _scrollView.frame.size.height;
    
    CGFloat offsetX = _scrollView.contentOffset.x;
    
    
    //三个imageView
    CGFloat cViewX = scrollViewW;
    CGFloat lViewX = cViewX - scrollViewW;
    CGFloat rViewX = cViewX + scrollViewW;
    
    if(_switchType == kHESwitchTypeFadeOut){
        cViewX = offsetX;
        lViewX = offsetX;
        rViewX = offsetX;
    }
    
    _centerView.frame   = CGRectMake(cViewX, 0, scrollViewW, scrollViewH);
    _leftView.frame     = CGRectMake(lViewX, 0, scrollViewW, scrollViewH);
    _rightView.frame    = CGRectMake(rViewX, 0, scrollViewW, scrollViewH);

}


- (void)layoutPageControl{
    
    CGFloat scrollViewW = _scrollView.frame.size.width;
    CGFloat scrollViewH = _scrollView.frame.size.height;
    
    CGSize pageControlS = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages];
    
    CGFloat pageControlX = 0;
    switch (_pageControlContentMode) {
        case kHEPageControlContentModeBottomLeft:
            pageControlX = _pageControlOffset.horizontal;
            
            break;
        case kHEPageControlContentModeBottomCenter:
            pageControlX = (scrollViewW - pageControlS.width) * 0.5;
            
            break;
        case kHEPageControlContentModeBottomRight:
            pageControlX = scrollViewW - pageControlS.width - _pageControlOffset.horizontal;
            
            break;
        default: break;
    }
    
    CGFloat pageControlY = scrollViewH - pageControlS.height + _pageControlOffset.vertical;
    _pageControl.frame = (CGRect){(CGPoint){pageControlX, pageControlY}, pageControlS};
    
}

#pragma mark - action
- (void)tapImageView:(UIGestureRecognizer *)recognizer{
    //代理传递事件
    if([_delegate respondsToSelector:@selector(infiniteScrollView:ItemOnclick:)]){
        [_delegate infiniteScrollView:self ItemOnclick:_currPage];
    }
}

#pragma mark - open
- (void)setContentObjs:(NSArray *)contentObjs Placeholder:(UIImage *)placeholder{
    _centerView.placeholder = placeholder;
    _leftView.placeholder = placeholder;
    _rightView.placeholder = placeholder;

    [self setContentObjs:contentObjs];
}

#pragma mark - private
#pragma mark 公有初始化方法
- (void)commonInit{
    
    //初始化scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self addSubview:scrollView];
    _scrollView = scrollView;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    
    //初始化仨imageView
    for(int i=0; i<3; i++){
        HEImageView *imageView = [[HEImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
        
        switch (i) {
            case 0: _centerView = imageView; break;
            case 1: _leftView = imageView; break;
            case 2: _rightView = imageView; break;
            default: break;
        }
    }


    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [self addSubview:pageControl];
    _pageControl = pageControl;

    //默认右下角偏移量
    _pageControlOffset = UIOffsetMake(10, 5);
    
    
    //开启自动滚动
    [self setupTimer];
}

- (void)setupTimer{
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval
                                              target:self
                                            selector:@selector(autoScroll)
                                            userInfo:nil
                                             repeats:YES];
}

#pragma mark 防止下标越界
- (int)indexPretreatment:(int)index{
    if(!_contentObjs.count) return 0;
    
    if(index < 0){
        index = (int)_contentObjs.count - 1;
        
    }else if(index > _contentObjs.count - 1){
        index = 0;
    }
    
    return index;
}

#pragma mark 自动滚动
- (void)autoScroll{
    if(_isScrolling) return;

    [UIView animateWithDuration:kAnimateDuration animations:^{
        _scrollView.userInteractionEnabled = NO;
        
        _beginDragOffsetX = _scrollView.contentOffset.x;
        CGFloat offsetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        [_scrollView setContentOffset:CGPointMake(offsetX, 0)];
        
    } completion:^(BOOL finished) {
        _scrollView.userInteractionEnabled = YES;
        
        [self scrollViewDidEndDecelerating:_scrollView];
    }];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if(_switchType == kHESwitchTypeFadeOut){
        
        CGFloat scrollViewW = _scrollView.frame.size.width;
        CGFloat offsetX = scrollView.contentOffset.x;
        
        CGFloat percent = ABS((offsetX - scrollViewW)) / scrollViewW;
        _centerView.alpha = 1 - percent;
        
        if(offsetX > _beginDragOffsetX){//下一张
            [_scrollView bringSubviewToFront:_rightView];
            
        }else if(offsetX < _beginDragOffsetX){
            [_scrollView bringSubviewToFront:_leftView];
        }
        
        [_scrollView bringSubviewToFront:_centerView];
        
        
        [self layoutContetImageViews];
    }
    
    
}



//将要开始拖拽，手指已经放在view上并准备拖动的那一刻
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _beginDragOffsetX = scrollView.contentOffset.x;
    
    _isScrolling = YES;
}
//已经结束拖拽，手指刚离开view的那一刻
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    scrollView.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        scrollView.userInteractionEnabled = YES;
    });
    
    [self setupTimer];
}

//已经停止滚动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //滑动中状态清除
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isScrolling = NO;
    });
    

    CGFloat offsetX = scrollView.contentOffset.x;
    
    if(ABS(offsetX - _beginDragOffsetX) >= scrollView.bounds.size.width){
//        NSLog(@"翻页");
        
        if(offsetX > _beginDragOffsetX){
//            NSLog(@"下一页");
            self.currPage++;
            
        }else{
//            NSLog(@"上一页");
            self.currPage--;
        }
    }
    
    //结束滚动 恢复到居中位置
    scrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width, 0);

}


#pragma mark set&get
- (void)setContentObjs:(NSArray *)contentObjs{
    _contentObjs = contentObjs;
    
    if(!_contentObjs.count) return;
    
    _pageControl.numberOfPages = _contentObjs.count;
    
    self.currPage = 0;
}

- (void)setCurrPage:(int)currPage{

    currPage = [self indexPretreatment:currPage];
    
    _currPage = currPage;
    
    //更新pageControl
    _pageControl.currentPage = currPage;

    int centerIndex = [self indexPretreatment:currPage];
    int leftIndex = [self indexPretreatment:currPage - 1];
    int rightIndex = [self indexPretreatment:currPage + 1];
    
    _centerView.contentObj = _contentObjs[centerIndex];
    _leftView.contentObj = _contentObjs[leftIndex];
    _rightView.contentObj = _contentObjs[rightIndex];
    
    //通知代理
    if([_delegate respondsToSelector:@selector(infiniteScrollView:DidFlipOver:)]){
        [_delegate infiniteScrollView:self DidFlipOver:_currPage];
    }
}
@end




