//
//  RxWebViewNavigationViewController.m
//  RxWebViewController
//
//  Created by roxasora on 15/10/23.
//  Copyright © 2015年 roxasora. All rights reserved.
//

#import "RxWebViewNavigationViewController.h"
#import "RxWebViewController.h"

@interface RxWebViewNavigationViewController ()<UINavigationBarDelegate>

@end

@implementation RxWebViewNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(UIViewController*)popViewControllerAnimated:(BOOL)animated{
//    if ([self.viewControllers.lastObject class] == [RxWebViewController class]) {
//        return [super popViewControllerAnimated:NO];
//    }
//    return [super popViewControllerAnimated:YES];
//}

-(BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    if ([self.viewControllers.lastObject class] == [RxWebViewController class]) {
        RxWebViewController* webVC = (RxWebViewController*)self.viewControllers.lastObject;
        if (webVC.webView.canGoBack) {
            [webVC.webView goBack];
            return NO;
        }else{
            [self popViewControllerAnimated:YES];
            return YES;
        }
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
