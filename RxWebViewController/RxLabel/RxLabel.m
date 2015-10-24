//
//  RxLabel.m
//  coreTextDemo
//
//  Created by roxasora on 15/10/8.
//  Copyright © 2015年 roxasora. All rights reserved.
//

#import "RxLabel.h"
#import <CoreText/CoreText.h>
#import "RxTextLinkTapView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RxUrlRegular @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
#define RxTopicRegular @"#[^#]+#"

#define rxHighlightTextTypeUrl @"url"

#define subviewsTag_linkTapViews -333
#define lineHeight_correction 3 //correct the line height

@interface RxLabel ()<RxTextLinkTapViewDelegate>

@end

@implementation RxLabel

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initProperties];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initProperties];
    }
    return self;
}

-(void)initProperties{
    _font = [UIFont systemFontOfSize:16];
    _textColor = UIColorFromRGB(0X333333);
    _linkButtonColor = UIColorFromRGB(0X2081ef);
    _linespacing = 0;
    _textAlignment = NSTextAlignmentLeft;
    
//    self.backgroundColor = [UIColor clearColor];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

-(void)setText:(NSString *)text{
    _text = text;
//    [self drawRect:self.bounds];
    [self setNeedsDisplay];
}

-(void)setFont:(UIFont *)font{
    _font = font;
    [self setNeedsDisplay];
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    [self setNeedsDisplay];
}

-(void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    [self setNeedsDisplay];
}

-(void)setLinkButtonColor:(UIColor *)linkButtonColor{
    _linkButtonColor = linkButtonColor;
    for (UIView* subview in self.subviews) {
        if (subview.tag == NSIntegerMin) {
            RxTextLinkTapView* buttonView = nil;
            buttonView = (RxTextLinkTapView*)subview;
            if (buttonView.type == RxTextLinkTapViewTypeDefault) {
                buttonView.backgroundColor = linkButtonColor;
            }
        }
    }
}

-(void)setlinespacing:(NSInteger)linespacing{
    _linespacing = linespacing;
    [self setNeedsDisplay];
}

-(void)setCustomUrlArray:(NSArray*)customUrlArray{
    _customUrlArray = customUrlArray;
    [self setNeedsDisplay];
}

static CTTextAlignment CTTextAlignmentFromNSTextAlignment(NSTextAlignment alignment){
    switch (alignment) {
        case NSTextAlignmentCenter: return kCTCenterTextAlignment;
        case NSTextAlignmentLeft:   return kCTLeftTextAlignment;
        case NSTextAlignmentRight:  return kCTRightTextAlignment;
        default:                    return kCTNaturalTextAlignment;
    }
}


#pragma mark - url replace run delegate
static CGFloat ascentCallback(void *ref){
    //!the height must fit the fontsize of titleView
    return [(__bridge UIFont*)ref pointSize] + 2;
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}

static CGFloat descentCallback(void *ref){
    return 0;
}

static CGFloat widthCallback(void* ref){
    return 70.0;
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}

#pragma mark - draw rect
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    if (self.backgroundColor) {
        CGContextSaveGState(context);
        CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
        CGContextFillRect(context, self.bounds);
        CGContextRestoreGState(context);
    }
    
    //translate the coordinate system to normal
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //create the draw path
    CGMutablePathRef path = CGPathCreateMutable();
    
    //挪动path的bound，避免(ಥ_ಥ) 这样的符号会画不出来
    //move the bound of path,or some words like (ಥ_ಥ) won't be drawn
    CGRect pathRect = self.bounds;
    pathRect.size.height += 5;
    pathRect.origin.y -= 5;
    CGPathAddRect(path, NULL, pathRect);
    
    //set line height font color and break mode
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)self.font.fontName, self.font.pointSize, NULL);
//    CGFloat minLineHeight = self.font.pointSize + lineHeight_correction,
//    maxLineHeight = minLineHeight,
    CGFloat linespacing = self.linespacing;
    
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;
    CTTextAlignment alignment = CTTextAlignmentFromNSTextAlignment(self.textAlignment);
    
    CTParagraphStyleRef style = CTParagraphStyleCreate((CTParagraphStyleSetting[4]){
        {kCTParagraphStyleSpecifierAlignment,sizeof(alignment),&alignment},
//        {kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(minLineHeight),&minLineHeight},
//        {kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(maxLineHeight),&maxLineHeight},
        {kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(linespacing),&linespacing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(linespacing),&linespacing},
        {kCTParagraphStyleSpecifierLineBreakMode,sizeof(lineBreakMode),&lineBreakMode}
    }, 4);
    
    NSDictionary* initAttrbutes = @{
                                    (NSString*)kCTFontAttributeName: (__bridge id)fontRef,
                                    (NSString*)kCTForegroundColorAttributeName:(id)self.textColor.CGColor,
                                    (NSString*)kCTParagraphStyleAttributeName:(id)style
                                    };
   
    //先从self text 中过滤掉 url ，将其保存在array中
    //filter the url string from origin text and generate the urlArray and the filtered text string
    /**
     @[
        @{
            @"range":@(m,n),
            @"urlStr":@"http://dsadd"
        }
     ]
     */
    NSMutableArray* urlArray = [NSMutableArray array];
    NSString* filteredText = [[NSString alloc] init];
    [RxLabel filtUrlWithOriginText:self.text urlArray:urlArray filteredText:&filteredText];
    
    //init the attributed string
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:filteredText
                                                                                attributes:initAttrbutes];
    //add url replaced run one by one with urlArray
    for (NSDictionary* urlItem in urlArray) {
        //init run callbacks
        CTRunDelegateCallbacks callbacks;
        memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
        callbacks.version = kCTRunDelegateVersion1;
        callbacks.getAscent = ascentCallback;
        callbacks.getDescent = descentCallback;
        callbacks.getWidth = widthCallback;
        CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void*)(self.font));
        
        NSRange range = [[urlItem objectForKey:@"range"] rangeValue];
        NSString* urlStr = [urlItem objectForKey:@"urlStr"];
        CFAttributedStringSetAttributes((CFMutableAttributedStringRef)attrStr, CFRangeMake(range.location, range.length), (CFDictionaryRef)@{
                                                                                                                                             (NSString*)kCTRunDelegateAttributeName:(__bridge id)delegate,
                                                                                                                                             @"url":urlStr
                                                                                                                                             }, NO);
        CFRelease(delegate);
    }
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrStr);
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, attrStr.length), path, NULL);
    
    //clear link tap views and create new link tap view
    for (UIView* subview in self.subviews) {
        if (subview.tag == NSIntegerMin) {
            [subview removeFromSuperview];
        }
    }
    
    //get lines in frame
    NSArray* lines = (NSArray*)CTFrameGetLines(frame);
    CFIndex lineCount = [lines count];
    
    //get origin point of each line
    CGPoint origins[lineCount];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    for (CFIndex index = 0; index < lineCount; index++) {
        //get line ref of line
        CTLineRef line = CFArrayGetValueAtIndex((CFArrayRef)lines, index);
        
        //get run
        CFArrayRef glyphRuns = CTLineGetGlyphRuns(line);
        CFIndex glyphCount = CFArrayGetCount(glyphRuns);
        for (int i = 0; i < glyphCount; i++) {
            CTRunRef run = CFArrayGetValueAtIndex(glyphRuns, i);
            
            NSDictionary* attrbutes = (NSDictionary*)CTRunGetAttributes(run);
            //create hover frame
            if ([attrbutes objectForKey:@"url"]) {
            
                CGRect runBounds;
                
                CGFloat ascent;
                CGFloat descent;
                runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
                runBounds.size.height = ascent + descent;
                
                //!make sure you've add the origin of the line, or your alignment will not work on url replace runs
                runBounds.origin.x = origins[index].x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                runBounds.origin.y = self.frame.size.height - origins[index].y - runBounds.size.height;
            
                //加上之前给 path 挪动位置时的修正
                //add correction of move the path
                runBounds.origin.y += 5;
            
    #ifdef RXDEBUG
                UIView* randomView = [[UIView alloc] initWithFrame:runBounds];
                randomView.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:0.2];
                [self addSubview:randomView];
    #endif
            
                NSString* urlStr = attrbutes[@"url"];
                RxTextLinkTapView* linkButtonView = [self linkButtonViewWithFrame:runBounds UrlStr:urlStr];
                [self addSubview:linkButtonView];
            }
        }
    }
    
    CTFrameDraw(frame, context);
    
    CFRelease(frame);
    CFRelease(frameSetter);
    CFRelease(path);
}

-(void)sizeToFit{
    [super sizeToFit];
    CGFloat height = [RxLabel heightForText:self.text width:self.bounds.size.width font:self.font linespacing:self.linespacing];
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

#pragma mark create link replace button with url
-(RxTextLinkTapView*)linkButtonViewWithFrame:(CGRect)frame UrlStr:(NSString*)urlStr{
    RxTextLinkTapView* buttonView = [[RxTextLinkTapView alloc] initWithFrame:frame
                                                                     urlStr:urlStr
                                                                       font:self.font
                                                                linespacing:self.linespacing];
    buttonView.tag = NSIntegerMin;
    buttonView.backgroundColor = self.linkButtonColor;
    buttonView.title = @"网页";
    buttonView.delegate = self;
    
    //handle custom url array
    for (NSDictionary* item in self.customUrlArray) {
        NSString* scheme = item[@"scheme"];
        //when match
        if ([urlStr rangeOfString:scheme].location != NSNotFound) {
            buttonView.type = RxTextLinkTapViewTypeCustom;
            buttonView.backgroundColor = UIColorFromRGB([item[@"color"] integerValue]);
            buttonView.title = item[@"title"];
        }
    }
    
    return buttonView;
}

#pragma mark - filter url and generate display text and url array
+(void)filtUrlWithOriginText:(NSString *)originText urlArray:(NSMutableArray *)urlArray filteredText:(NSString *__autoreleasing *)filterText{
    *filterText = [NSString stringWithString:originText];
    NSArray* urlMatches = [[NSRegularExpression regularExpressionWithPattern:RxUrlRegular
                                                                     options:NSRegularExpressionDotMatchesLineSeparators error:nil]
                           matchesInString:originText
                           options:0
                           range:NSMakeRange(0, originText.length)];

    //range 的偏移量，每次replace之后，下次循环中，要加上这个偏移量
//    NSLog(@"origin text %@ matched%@",originText,urlMatches);
    NSInteger rangeOffset = 0;
    for (NSTextCheckingResult* match in urlMatches) {
        NSRange range = match.range;
        NSString* urlStr = [originText substringWithRange:range];
        
        range.location += rangeOffset;
        rangeOffset -= (range.length - 1);
       
        unichar objectReplacementChar = 0xFFFC;
        NSString * replaceContent = [NSString stringWithCharacters:&objectReplacementChar length:1];
        *filterText = [*filterText stringByReplacingCharactersInRange:range withString:replaceContent];
        
        range.length = 1;
        [urlArray addObject:@{
                              @"range":[NSValue valueWithRange:range],
                              @"urlStr":urlStr
                              }];
    }
}

#pragma mark - get height for particular configs
+(CGFloat)heightForText:(NSString *)text width:(CGFloat)width font:(UIFont *)font linespacing:(CGFloat)linespacing{
    CGFloat height = 0;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, width, 9999));
    
    //set line height font color and break mode
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    
//    CGFloat minLineHeight = font.pointSize + lineHeight_correction,
//    maxLineHeight = minLineHeight;
    
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;
    CTTextAlignment alignment = kCTLeftTextAlignment;
    
    CTParagraphStyleRef style = CTParagraphStyleCreate((CTParagraphStyleSetting[4]){
        {kCTParagraphStyleSpecifierAlignment,sizeof(alignment),&alignment},
//        {kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(minLineHeight),&minLineHeight},
//        {kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(maxLineHeight),&maxLineHeight},
        {kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(linespacing),&linespacing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(linespacing),&linespacing},
        {kCTParagraphStyleSpecifierLineBreakMode,sizeof(lineBreakMode),&lineBreakMode}
    }, 4);
    
    
    NSDictionary* initAttrbutes = @{
                                    (NSString*)kCTFontAttributeName: (__bridge id)fontRef,
                                    (NSString*)kCTParagraphStyleAttributeName:(id)style
                                    };
    
    NSMutableArray* urlArray = [NSMutableArray array];
    NSString* filteredText = [[NSString alloc] init];
    [RxLabel filtUrlWithOriginText:text urlArray:urlArray filteredText:&filteredText];
    
    //create the initial attributed string
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:filteredText
                                                                                attributes:initAttrbutes];
    for (NSDictionary* urlItem in urlArray) {
        //init run callbacks
        CTRunDelegateCallbacks callbacks;
        memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
        callbacks.version = kCTRunDelegateVersion1;
        callbacks.getAscent = ascentCallback;
        callbacks.getDescent = descentCallback;
        callbacks.getWidth = widthCallback;
        CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void*)(font));
        
        NSRange range = [[urlItem objectForKey:@"range"] rangeValue];
        NSString* urlStr = [urlItem objectForKey:@"urlStr"];
        CFAttributedStringSetAttributes((CFMutableAttributedStringRef)attrStr, CFRangeMake(range.location, range.length), (CFDictionaryRef)@{
                                                                                                                                             (NSString*)kCTRunDelegateAttributeName:(__bridge id)delegate,
                                                                                                                                             @"url":urlStr
                                                                                                                                             }, NO);
        CFRelease(delegate);
    }
    

    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrStr);
    
    CGSize restrictSize = CGSizeMake(width, 10000);
    CGSize coreTestSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), nil, restrictSize, nil);
//    NSLog(@"calcuted size %@",[NSValue valueWithCGSize:coreTestSize]);
    
    height = coreTestSize.height;
    height += 5;
    
    return height;
}

#pragma mark - RxTextLinkTapView delegate
-(void)RxTextLinkTapView:(RxTextLinkTapView *)linkTapView didDetectTapWithUrlStr:(NSString *)urlStr{
//    NSLog(@"link tapped !! %@",urlStr);
    if ([self.delegate respondsToSelector:@selector(RxLabel:didDetectedTapLinkWithUrlStr:)]) {
        [self.delegate RxLabel:self didDetectedTapLinkWithUrlStr:urlStr];
    }
}

-(void)RxTextLinkTapView:(RxTextLinkTapView *)linkTapView didBeginHighlightedWithUrlStr:(NSString *)urlStr{
//    [self setOtherLinkTapViewHightlighted:YES withUrlStr:urlStr];
}

-(void)RxTextLinkTapView:(RxTextLinkTapView *)linkTapView didEndHighlightedWithUrlStr:(NSString *)urlStr{
//    [self setOtherLinkTapViewHightlighted:NO withUrlStr:urlStr];
}

-(void)setOtherLinkTapViewHightlighted:(BOOL)hightlighted withUrlStr:(NSString*)urlStr{
    for (UIView* subview in self.subviews) {
        if (subview.tag == NSIntegerMin) {
            RxTextLinkTapView* lineTapView = (RxTextLinkTapView*)subview;
            if ([lineTapView.urlStr isEqualToString:urlStr] && lineTapView.highlighted != hightlighted) {
                [lineTapView setHighlighted:hightlighted];
            }
        }
    }
}

@end
