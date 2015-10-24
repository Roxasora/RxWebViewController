//
//  RxTextLinkTapView.m
//  coreTextDemo
//
//  Created by roxasora on 15/10/9.
//  Copyright © 2015年 roxasora. All rights reserved.
//

#import "RxTextLinkTapView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define titleFontSize 12

@interface RxTextLinkTapView ()

@property (nonatomic)UILabel* titleLabel;

@end
@implementation RxTextLinkTapView

-(UILabel*)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - titleFontSize)/2, self.frame.size.width, titleFontSize)];
        _titleLabel.font = [UIFont systemFontOfSize:titleFontSize];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = self.title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 3;
        self.highlighted = NO;
        self.backgroundColor = [UIColor clearColor];
        self.type = RxTextLinkTapViewTypeDefault;
//        self.isReplaceUrl =YES;
        
        self.title = @"网页";
        self.linespacing = 0;
        
        [self addSubview:self.titleLabel];
        
        UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame urlStr:(NSString *)urlStr font:(UIFont *)font linespacing:(CGFloat)linespacing{
    frame.origin.y += (font.pointSize/16 * 2.8);
    
    self = [self initWithFrame:frame];
    self.urlStr = urlStr;
    self.linespacing = linespacing;
    return self;
}

/*
-(void)setIsReplaceUrl:(BOOL)isReplaceUrl{
    _isReplaceUrl = isReplaceUrl;
    //如果替换，就显示为有颜色的，固体的
    if (isReplaceUrl) {
        self.backgroundColor = UIColorFromRGB(0X389ae5);
        [self addSubview:self.titleLabel];
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
}
 */

-(void)setTitle:(NSString *)title{
    _title = title;
    if (self.titleLabel) {
        self.titleLabel.text = title;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
    [self setHighlighted:YES];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    [self setHighlighted:NO];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self setHighlighted:NO];
}

-(void)setHighlighted:(BOOL)highlighted{
    _highlighted = highlighted;
    //    NSLog(@"cao nim ");
    if (highlighted) {
        self.alpha = 0.55;
        if ([self.delegate respondsToSelector:@selector(RxTextLinkTapView:didBeginHighlightedWithUrlStr:)]) {
            [self.delegate RxTextLinkTapView:self didBeginHighlightedWithUrlStr:self.urlStr];
        }
    }else{
        self.alpha = 1;
        if ([self.delegate respondsToSelector:@selector(RxTextLinkTapView:didEndHighlightedWithUrlStr:)]) {
            [self.delegate RxTextLinkTapView:self didEndHighlightedWithUrlStr:self.urlStr];
        }
    }
}

/*
-(void)setHighlighted:(BOOL)highlighted{
    _highlighted = highlighted;
//    NSLog(@"cao nim ");
    if (!self.isReplaceUrl) {
        if (highlighted) {
            self.backgroundColor = self.tapColor;
            if ([self.delegate respondsToSelector:@selector(RxTextLinkTapView:didBeginHighlightedWithUrlStr:)]) {
                [self.delegate RxTextLinkTapView:self didBeginHighlightedWithUrlStr:self.urlStr];
            }
        }else{
            self.backgroundColor = [UIColor clearColor];
            if ([self.delegate respondsToSelector:@selector(RxTextLinkTapView:didEndHighlightedWithUrlStr:)]) {
                [self.delegate RxTextLinkTapView:self didEndHighlightedWithUrlStr:self.urlStr];
            }
        }
    }else{
        if (highlighted) {
//            self.titleLabel.alpha = 0.6;
//            self.backgroundColor = UIColorFromRGB(0X2a7dbe);
            self.alpha = 0.55;
            if ([self.delegate respondsToSelector:@selector(RxTextLinkTapView:didBeginHighlightedWithUrlStr:)]) {
                [self.delegate RxTextLinkTapView:self didBeginHighlightedWithUrlStr:self.urlStr];
            }
        }else{
//            self.titleLabel.alpha = 1;
//            self.backgroundColor = UIColorFromRGB(0X389ae5);
//            self.backgroundColor = self.tapColor;
            self.alpha = 1;
            if ([self.delegate respondsToSelector:@selector(RxTextLinkTapView:didEndHighlightedWithUrlStr:)]) {
                [self.delegate RxTextLinkTapView:self didEndHighlightedWithUrlStr:self.urlStr];
            }
        }
    }
}
 */

-(void)handleTap:(UITapGestureRecognizer*)sender{
    [self setHighlighted:YES];
    [self performSelector:@selector(backToNormal) withObject:nil afterDelay:0.25];
    if ([self.delegate respondsToSelector:@selector(RxTextLinkTapView:didDetectTapWithUrlStr:)]) {
        [self.delegate RxTextLinkTapView:self didDetectTapWithUrlStr:self.urlStr];
    }
}

-(void)backToNormal{
    [self setHighlighted:NO];
}
@end
