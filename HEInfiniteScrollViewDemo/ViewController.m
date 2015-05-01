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

    NSArray *images = @[ [UIImage imageNamed:@"image01.jpg"],
                         [UIImage imageNamed:@"image02.jpg"],
                         [UIImage imageNamed:@"image03.jpg"],
                         [UIImage imageNamed:@"image04.jpg"],
                         [UIImage imageNamed:@"image05.jpg"],
                         [NSURL URLWithString:@"http://i1.tietuku.com/710f29f1d57ac35d.jpg"],
                         ];
    
    _infiniteScrollView.delegate = self;
    [_infiniteScrollView setContentObjs:images
                            Placeholder:[UIImage imageNamed:@"placeholder.jpg"]];

}

#pragma mark - HEInfiniteScrollViewDelegate
- (void)infiniteScrollView:(HEInfiniteScrollView *)infiniteScrollView ItemOnclick:(NSUInteger)index{
    NSLog(@"click - %zd", index);
}

@end
