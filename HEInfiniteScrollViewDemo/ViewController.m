//
//  ViewController.m
//  HEInfiniteScrollViewDemo
//
//  Created by 贺瑞 on 15/5/1.
//  Copyright (c) 2015年 herui. All rights reserved.
//

#import "ViewController.h"
#import "HEInfiniteScrollView.h"

@interface ViewController ()<HEInfiniteScrollViewDelegate>

@property (weak, nonatomic) IBOutlet HEInfiniteScrollView *infiniteScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    redView.backgroundColor = [UIColor redColor];
    

    NSArray *images = @[ [UIImage imageNamed:@"image01.jpg"],
                         [UIImage imageNamed:@"image02.jpg"],
                         [UIImage imageNamed:@"image03.jpg"],
                         [UIImage imageNamed:@"image04.jpg"],
                         [UIImage imageNamed:@"image05.jpg"],
                         [NSURL URLWithString:@"http://i1.tietuku.com/710f29f1d57ac35d.jpg"],
                         redView,
                         ];
    
    _infiniteScrollView.delegate = self;
    [_infiniteScrollView setContentObjs:images
                            Placeholder:[UIImage imageNamed:@"placeholder.jpg"]];
    
    
    {
        UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        orangeView.backgroundColor = [UIColor orangeColor];
        NSArray *images = @[ [UIImage imageNamed:@"image01.jpg"],
                             [UIImage imageNamed:@"image02.jpg"],
                             [UIImage imageNamed:@"image03.jpg"],
                             [UIImage imageNamed:@"image04.jpg"],
                             [UIImage imageNamed:@"image05.jpg"],
                             [NSURL URLWithString:@"http://i1.tietuku.com/710f29f1d57ac35d.jpg"],
                             orangeView,
                             ];
        HEInfiniteScrollView *infiniteScrollView = [[HEInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 228, self.view.frame.size.width, 200)];
        [self.view addSubview:infiniteScrollView];
        [infiniteScrollView setContentObjs:images Placeholder:[UIImage imageNamed:@"image02.jpg"]];
        infiniteScrollView.pageControlContentMode = kHEPageControlContentModeBottomCenter;
        infiniteScrollView.switchType = kHESwitchTypeFadeOut;
//        infiniteScrollView.delegate = self;
    }

}

#pragma mark - HEInfiniteScrollViewDelegate
- (void)infiniteScrollView:(HEInfiniteScrollView *)infiniteScrollView ItemOnclick:(NSUInteger)index{
    NSLog(@"click - %zd", index);
}

- (void)infiniteScrollView:(HEInfiniteScrollView *)infiniteScrollView DidFlipOver:(NSUInteger)pageNum{
    NSLog(@"pageNum - %zd", pageNum);
}

@end
