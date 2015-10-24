# Rxlabel

###it's a custom UIWebViewController that navigate like navigationController,just like wechat do.
###实现类似微信的webView导航效果，左滑返回上个网页，就像UINavigationController 


like the screen shot gif

![image](http://img.hb.aicdn.com/2f0b4c69b8926b2ebf9dd21503abb5a2305aab58124b5d-GWa5HK_fw658)

### usage使用

####Install 安装
You just need to drag/copy the "RxWebViewController" folder and drop in your project
将“RxWebViewController”文件夹拖进你的工程中即可

####init and push 

usage is simple
   		
   		NSString* urlStr = @"http://github.com";
		RxWebViewController* webViewController = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:urlStr]];
    	[self.navigationController pushViewController:webViewController animated:YES];

####and if you want to do some custom things with webview,just subclass it 如果你需要webview的更进一步自定义，子类化即可
		@interface myWebViewController : RxWebViewController

		//do your custom things

		@end
                                
                                
####navigation bar tint color and back button style 导航栏的颜色和返回按钮样式
导航栏中出现的 返回 和 关闭 ，均会继承你的 navigationController 中对 navigationBar 的设置，你可以这样：

		UIColor* tintColor = [UIColor whiteColor];
    	UIColor* barTintColor = [UIColor blueColor];
		self.navigationController.navigationBar.tintColor = tintColor;
    	self.navigationController.navigationBar.barTintColor = barTintColor;
    	[self.navigationController.navigationBar setTitleTextAttributes:@{                                                          										NSForegroundColorAttributeName:tintColor
                                                                      }];
                                                                      
 这样来自定义你的navigationBar颜色，webViewController中会遵循此设置，如图
 ![image](http://img.hb.aicdn.com/3a291ebfe090a2b8bebde15e10e7217152af6e1cbb52-cRpmNk_fw658)
 
 
 **也可以像微信那样在你的 navigationBar 中使用自定义的 backButtonBackgroundImage，如图**
 
 ![image](http://img.hb.aicdn.com/ab84843887791178ba8764b9bde04f4b34f338cc10f8e-1umnI5_fw658)