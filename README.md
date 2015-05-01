HEInfiniteScrollView
=========

一个简单的图片轮播器

![(App01)](http://i1.tietuku.com/df4a1ae5fd3f0605.gif)


怎么用？
----------

```objective-c

#import "HEInfiniteScrollView.h"

NSArray *images = @[[UIImage imageNamed:@"image01.jpg"], 
                    [UIImage imageNamed:@"image02.jpg"], 
                    [UIImage imageNamed:@"image03.jpg"],
                    [UIImage imageNamed:@"image04.jpg"], 
                    [UIImage imageNamed:@"image05.jpg"],
                    [NSURL URLWithString:@"http://i1.tietuku.com/710f29f1d57ac35d.jpg"],
                    ];  

[_infiniteScrollView setContentObjs:images Placeholder:[UIImage imageNamed:@"placeholder.jpg"]];

```
