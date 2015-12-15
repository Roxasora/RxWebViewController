//
//  RxTextLinkTapView.h
//  coreTextDemo
//
//  Created by roxasora on 15/10/9.
//  Copyright © 2015年 roxasora. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RxTextLinkTapViewTypeDefault,
    RxTextLinkTapViewTypeCustom
} RxTextLinkTapViewType;

@protocol RxTextLinkTapViewDelegate;

@interface RxTextLinkTapView : UIView

/**
 *  create instance with frame and url
 *
 *  @param frame  frame
 *  @param urlStr nsstring url
 *
 *  @return instance
 */
-(id)initWithFrame:(CGRect)frame urlStr:(NSString*)urlStr font:(UIFont*)font linespacing:(CGFloat)linespacing;

/**
 *  delegate
 */
@property id<RxTextLinkTapViewDelegate> delegate;

/**
 *  type of tap view,default has same bg color, custom has own bg color
 */
@property (nonatomic) RxTextLinkTapViewType type;

/**
 *  nsstring url
 */
@property (nonatomic)NSString* urlStr;

/**
 *  hightlighted just like uibutton
 */
@property (nonatomic)BOOL highlighted;

/**
 *  color when tapped
 */
@property (nonatomic)UIColor* tapColor;

/**
 *  line height of parent text view default is 0
 */
@property (nonatomic)CGFloat linespacing;

/**
 *  Deprecated... if replace the url,if yes then show a small round corner button with title, if no then show a hover layer
 */
//@property (nonatomic)BOOL isReplaceUrl;

/**
 *  replaced title
 */
@property (nonatomic)NSString* title;

@end

@protocol RxTextLinkTapViewDelegate <NSObject>

-(void)RxTextLinkTapView:(RxTextLinkTapView*)linkTapView didDetectTapWithUrlStr:(NSString*)urlStr;
-(void)RxTextLinkTapView:(RxTextLinkTapView*)linkTapView didBeginHighlightedWithUrlStr:(NSString*)urlStr;
-(void)RxTextLinkTapView:(RxTextLinkTapView*)linkTapView didEndHighlightedWithUrlStr:(NSString*)urlStr;

@end
