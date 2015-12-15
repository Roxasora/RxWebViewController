//
//  myNormalViewController.m
//  RxWebViewController
//
//  Created by 范斌 on 15/12/9.
//  Copyright © 2015年 roxasora. All rights reserved.
//

#import "myNormalViewController.h"

@interface myNormalViewController ()
- (IBAction)btnClicked:(id)sender;
- (IBAction)popBtnClicked:(id)sender;

@end

@implementation myNormalViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnClicked:(id)sender {
    myNormalViewController* vc = [[myNormalViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)popBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
