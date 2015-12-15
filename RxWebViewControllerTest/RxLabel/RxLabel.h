//
//  RxLabel.h
//  coreTextDemo
//
//  Created by roxasora on 15/10/8.
//  Copyright © 2015年 roxasora. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RxLabelDelegate;

@interface RxLabel : UIView

@property id<RxLabelDelegate> delegate;


/**
 *  text
 */
@property (nonatomic,copy)NSString* text;

/**
 *  textColor default is #333333
 */
@property (nonatomic,strong)UIColor* textColor;

/**
 *  text alignment with NSTextAlignment
 */
@property (nonatomic) NSTextAlignment textAlignment;

/**
 *  font default is 16
 */
@property (nonatomic,strong)UIFont* font;

/**
 *  linespacing default is 0
 */
@property (nonatomic)NSInteger linespacing;

/**
 *  color of link button,default is custom blue
 */
@property (nonatomic)UIColor* linkButtonColor;


/**
 *  custom the color array of your own urls, like orange taobao, red tmall, and green douban
 @[
 @{
 @"scheme":@"taobao",
 @"title":@"淘宝",
 @"color":@0Xff0000
 }
 ]
 */
@property (nonatomic,copy)NSArray* customUrlArray;

//**
// *  add custom url button with your own config
// *
// *  @param scheme          scheme
// *  @param title           title to display
// *  @param backgroundColor bgcolor
// */
//-(void)addCustomUrlButtonWithScheme:(NSString*)scheme title:(NSString*)title backgroundColor:(UIColor*)backgroundColor;

/**
 *  get height with text width font and spacing
 *
 *  @param text text
 *  @param width width
 *  @param font font
 *  @param linespacing spacing
 *
 *  @return float height
 */

/**
 *  fit the best size
 */
-(void)sizeToFit;

+(CGFloat)heightForText:(NSString*)text width:(CGFloat)width font:(UIFont*)font linespacing:(CGFloat)linespacing;
+(void)filtUrlWithOriginText:(NSString*)originText urlArray:(NSMutableArray*)urlArray filteredText:(NSString**)filterText;

@end

@protocol RxLabelDelegate <NSObject>

-(void)RxLabel:(RxLabel*)label didDetectedTapLinkWithUrlStr:(NSString*)urlStr;

@end
