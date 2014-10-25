//
//  AttributedLabel.m
//  AttributedStringTest
//
//  Created by sun huayu on 13-2-19.
//  Copyright (c) 2013年 sun huayu. All rights reserved.
//

#import "AttributedLabel.h"

@interface AttributedLabel(){
    
}
@property (nonatomic,retain)NSMutableAttributedString          *attString;
@end

@implementation AttributedLabel
@synthesize attString = _attString;

- (void)dealloc{
    [_attString release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.numberOfLines = 0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();//注，像许多低级别的API，核心文本使用的Y翻转坐标系 更杯具的是，内容是也渲染的翻转向下！
    //手动翻转,注，每次使用可将下面三句话复制粘贴过去。必用
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGMutablePathRef path = CGPathCreateMutable();//1,外边框。mac支持矩形和圆，ios仅支持矩形。本例中使用self.bounds作为path的reference
    CGPathAddRect(path, NULL, self.bounds);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attString);//3CTFramesetter是最重要的类时使用的绘图核心文本。管理您的字体引用和绘制文本框。就目前而言，你需要知道什么是CTFramesetterCreateWithAttributedString为您将创建一个CTFramesetter的，保留它，并使用附带的属性字符串初始化。在本节中，你有framesetter后你创建一个框架，你给CTFramesetterCreateFrame，呈现了一系列的字符串（我们选择这里的整个字符串）和矩形绘制文本时会出现。
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [_attString length]), path, NULL);
    CTFrameDraw(frame, context);//4绘制
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
    
}

- (void)setText:(NSString *)text{
    [super setText:text];
    if (text == nil) {
        self.attString = nil;
    }else{
        self.attString = [[[NSMutableAttributedString alloc] initWithString:text] autorelease];
    }
}

// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTForegroundColorAttributeName
                       value:(id)color.CGColor
                       range:NSMakeRange(location, length)];
}

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTFontAttributeName
                       value:(id)CTFontCreateWithName((CFStringRef)font.fontName,
                                                      font.pointSize,
                                                      NULL)
                       range:NSMakeRange(location, length)];
}

// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                       value:(id)[NSNumber numberWithInt:style]
                       range:NSMakeRange(location, length)];
}

- (int)getAttributedStringHeightWithStringByWidthValue:(int) width
{
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attString);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 1000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 1000 - line_y + (int) descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    return total_height;
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
