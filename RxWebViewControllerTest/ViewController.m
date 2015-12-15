//
//  ViewController.m
//  RxWebViewController
//
//  Created by roxasora on 15/10/23.
//  Copyright © 2015年 roxasora. All rights reserved.
//

#import "ViewController.h"
#import "RxLabel.h"
#import "RxWebViewController.h"
#import "myNormalViewController.h"

#define UIColorFromHexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()<RxLabelDelegate>

@property (strong, nonatomic) IBOutlet RxLabel *label;

- (IBAction)navigationStyleSegmentChanged:(id)sender;
- (IBAction)addItemClicked:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"RxWebViewController";
    
    self.label.delegate = self;
    self.label.text = @"长者，指年纪大、辈分高、德高望重的人。一般多用于对别人的尊称，也可用于自称。能被称为长者的人往往具有丰富的人生经验，可以帮助年轻人提高姿势水平 http://github.com/roxasora";
    self.label.customUrlArray = @[
                                  @{
                                      @"scheme":@"baidu",
                                      @"color":@0X459df5,
                                      @"title":@"百度"
                                  },
                                  @{
                                      @"scheme":@"github",
                                      @"color":@0X333333,
                                      @"title":@"Github"
                                      }
                                  ];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = UIColorFromHexRGB(0X151515);
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                      }];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //set custom back button image
//    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationController class]]] setBackButtonBackgroundImage:[UIImage imageNamed:@"icon-nav-backButton-bg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

-(void)RxLabel:(RxLabel *)label didDetectedTapLinkWithUrlStr:(NSString *)urlStr{
    RxWebViewController* webViewController = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:urlStr]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)navigationStyleSegmentChanged:(id)sender {
    UISegmentedControl* seg = (UISegmentedControl*)sender;
    
    UIColor* tintColor;
    UIColor* barTintColor;
    switch (seg.selectedSegmentIndex) {
        case 0:
        {
            tintColor = [UIColor whiteColor];
            barTintColor = UIColorFromHexRGB(0X151515);
        }
            break;
        case 1:
        {
            tintColor = [UIColor redColor];
            barTintColor = [UIColor blueColor];
        }
            break;
        case 2:
        {
            tintColor = [UIColor whiteColor];
            barTintColor = UIColorFromHexRGB(0X4BAFF3);
        }
            break;
            
        default:
            break;
    }
    
    self.navigationController.navigationBar.tintColor = tintColor;
    self.navigationController.navigationBar.barTintColor = barTintColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:tintColor
                                                                      }];
}

- (IBAction)addItemClicked:(id)sender {
    myNormalViewController* vc = [[myNormalViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)

@end


