//
//  UINavigationController+RxWebViewNavigation.m
//  RxWebViewController
//
//  Created by roxasora on 15/10/23.
//  Copyright © 2015年 roxasora. All rights reserved.
//

#import "RxWebViewController.h"
#import <objc/runtime.h>

@implementation UINavigationController (RxWebViewNavigation)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // UINavigationController 实现了协议方法 navigationBar:shouldPopItem:，因此为了省事就直接交换了
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(navigationBar:shouldPopItem:)),
                                       class_getInstanceMethod(self, @selector(rx_navigationBar:shouldPopItem:)));
    });
}

// 改进思路来自 [截获导航控制器系统返回按钮的点击pop及右滑pop事件](http://www.jianshu.com/p/6376149a2c4c)
- (BOOL)rx_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    UIViewController *topVC = self.topViewController;

    // 通过代码 pop 时，顶层视图控制器出栈后，此方法才会被调用
    // 也就是说，此时获取到的顶层视图控制器其实是原顶层视图控制器的上一层视图控制器
    // 而参数 item 却依然是原顶层视图控制器的 navigationItem
    // 因此，如果 navigationItem 不同，就说明此方法是因为通过代码 pop 而调用的，此时应该沿用默认实现
    if (item != topVC.navigationItem) {
        return [self rx_navigationBar:navigationBar shouldPopItem:item];
    }
    
    // 能来到这里说明此方法是由于点击返回按钮而调用的，此时顶层视图控制器尚未出栈
    // 若顶层视图控制器是 RxWebViewController，并且网页可以返回，此时应该将网页返回，而不是 pop 顶层视图控制器
    if ([topVC isKindOfClass:[RxWebViewController class]]) {
        RxWebViewController *webVC = (RxWebViewController*)topVC;
        if (webVC.webView.canGoBack) {
            [webVC.webView goBack];
            // 最后一个子视图即是返回按钮图片，由于 pop 操作，它会变淡
            // 而此时希望取消 pop 操作，并不希望返回按钮图片变淡，因此重新恢复它的透明度
            [[self.navigationBar subviews] lastObject].alpha = 1;
            // 由于此时不希望 pop，因此返回 NO
            return NO;
        }
        // 虽然顶层视图控制器是 RxWebViewController，但是网页不可返回上一页了
        // 此时应该像普通情况一样 pop 顶层视图控制器，因此这里应该沿用默认实现
        return [self rx_navigationBar:navigationBar shouldPopItem:item];
    }

    // 来到这里说明此方法是由于点击返回按钮而调用的，此时顶层视图控制器尚未出栈，但它不是 RxWebViewController
    // 此时也应该像普通情况一样 pop 顶层视图控制器，因此这里同样应该沿用默认实现
    return [self rx_navigationBar:navigationBar shouldPopItem:item];
}

@end
