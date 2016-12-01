//
//  CutView.m
//  ImageTool
//
//  Created by my on 2016/11/23.
//  Copyright © 2016年 my. All rights reserved.
//

#import "CutImageView.h"


static CGFloat pointWidth = 25;//圆点的直径
static CGFloat edgeOffset = 10;//判断边缘的范围

//缩放的点击区域
typedef enum : NSInteger {
    ScaleTypeNone,//拖动
    ScaleTypeLeft,
    ScaleTypeTop,
    ScaleTypeRight,
    ScaleTypeBottom,
    
    ScaleTypeLeftTop,
    ScaleTypeLeftBottom,
    ScaleTypeRightTop,
    ScaleTypeRightBottom
    
} ScaleType;


@interface CutImageView ()
{
    CAShapeLayer *grid;
    
    NSMutableArray *pointArray;
    NSMutableArray *layerArray;
    
    CGPoint startPoint;
    CGRect startFrame;
    
    ScaleType scaleType;
    
    CAShapeLayer *maskLayer;
    
}

@property (nonatomic, strong) UIView *cutView;

@end


@implementation CutImageView

- (instancetype)initWithFrame:(CGRect)frame type:(CutImageClipType)type {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        _lineColor = [UIColor redColor];
        
        self.clipType = type;

        [self drawView:_cutView];
        [self addSubview:self.cutView];
        
        self.clipType = type;

    }
    return self;
}
- (void)setClipType:(CutImageClipType)clipType {
    _clipType = clipType;
    switch (clipType) {
        case CutImageClipDefault:
        {
            self.cutView.hidden = NO;
            self.cutView.frame = self.bounds;
            pointArray = [self pointArray];
        }
            break;
        case CutImageClipCustom:
        {
            if (self.cutView) {
                self.cutView.hidden = YES;
            }
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 矩形剪切点
- (NSMutableArray *)pointArray {
    return [NSMutableArray arrayWithArray:@[[NSValue valueWithCGPoint:CGPointMake(0, 0)],
                                            [NSValue valueWithCGPoint:CGPointMake(_cutView.bounds.size.width, 0)],
                                            [NSValue valueWithCGPoint:CGPointMake(_cutView.bounds.size.width, _cutView.bounds.size.height)],
                                            [NSValue valueWithCGPoint:CGPointMake(0, _cutView.bounds.size.height)]
                                            ]];
}

#pragma mark - 矩形剪切蒙版
- (UIView *)cutView {
    if (!_cutView) {
        _cutView = [[UIView alloc] initWithFrame:self.bounds];
        _cutView.backgroundColor = [UIColor clearColor];
        [self addPanGes:_cutView];
    }
    return _cutView;
}
#pragma mark - 根据点画遮罩层
- (void)drawMask:(UIView *)view {
    if (!maskLayer) {
        maskLayer = [CAShapeLayer layer];
        UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:self.bounds];
        maskLayer.path = path1.CGPath;
        maskLayer.fillColor = [UIColor colorWithWhite:0 alpha:.2].CGColor;
        [self.layer addSublayer:maskLayer];
    }


    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < pointArray.count; i ++) {
        CGPoint point = [pointArray[i] CGPointValue];
        if (i == 0) {
            [path moveToPoint:point];
        } else {
            [path addLineToPoint:point];
        }
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = _cutView.frame;
    shapeLayer.path = path.CGPath;
    [maskLayer setMask:shapeLayer];
}


#pragma mark - 矩形区域绘制网格
- (void)drawView:(UIView *)cutView {
    if (!grid) {
        grid = [[CAShapeLayer alloc] init];
        grid.strokeColor = _lineColor.CGColor;
        grid.lineWidth = 1.5;
        grid.lineCap = kCALineCapButt;
        grid.lineJoin = kCALineJoinBevel;
        grid.fillColor = [UIColor clearColor].CGColor;
        [cutView.layer addSublayer:grid];
    }

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:cutView.bounds];
    //添加分割线
    for (NSInteger i = 1; i <= 2; i++) {
        [path appendPath:[self linePathStart:CGPointMake(i * cutView.bounds.size.width/3, 0) end:CGPointMake(i * cutView.bounds.size.width/3, cutView.bounds.size.height)]];
    }
    
    for (NSInteger i = 1; i <= 2; i++) {
        [path appendPath:[self linePathStart:CGPointMake(0, i * cutView.bounds.size.height/3) end:CGPointMake(cutView.bounds.size.width, i * cutView.bounds.size.height/3)]];
    }
    
    grid.path = path.CGPath;
    

    if (!layerArray) {
        layerArray = [NSMutableArray arrayWithCapacity:pointArray.count];
        for (NSInteger i = 0; i < pointArray.count; i ++) {
            CAShapeLayer *layer = [self roundPathCenter:[pointArray[i] CGPointValue] radius:pointWidth];
            layer.fillColor = _lineColor.CGColor;
            [layerArray addObject:layer];
            [cutView.layer addSublayer:layer];
        }
    } else {
        pointArray = [self pointArray];
        for (NSInteger i = 0; i < layerArray.count; i++) {
            CAShapeLayer *layer = layerArray[i];
            CGPoint point = [pointArray[i] CGPointValue];
            layer.path = [self centerPath:point radius:pointWidth].CGPath;
        }
    }
    
    [self drawMask:self];

}

#pragma mark - 绘制线
- (UIBezierPath *)linePathStart:(CGPoint)start end:(CGPoint)end {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:start];
    [path addLineToPoint:end];
    return path;
}

#pragma mark - 绘制点
- (UIBezierPath *)centerPath:(CGPoint)center radius:(CGFloat)radius {
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(center.x - radius/2, center.y - radius/2, radius, radius)];
    return path;
}
- (CAShapeLayer *)roundPathCenter:(CGPoint)center radius:(CGFloat)radius {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = _lineColor.CGColor;
    layer.path = [self centerPath:center radius:radius].CGPath;
    return layer;
}


#pragma mark - 平移手势
- (void)addPanGes:(UIView *)view {
    UIPanGestureRecognizer *ges = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:ges];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    startPoint = [touch locationInView:touch.view];
    scaleType = scaleOrDrag(startPoint, touch.view);
    startFrame = touch.view.frame;
}

- (void)panAction:(UIPanGestureRecognizer *)ges {
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
        {

        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint trans = [ges translationInView:ges.view];
            switch (scaleType) {
                case ScaleTypeNone:
                {
                    CGRect frame = ges.view.frame;
                    frame.origin = CGPointMake(MAX(0, MIN(self.frame.size.width - frame.size.width, startFrame.origin.x + trans.x)),
                                               MAX(0, MIN(self.frame.size.height - frame.size.height, startFrame.origin.y + trans.y)));
                    ges.view.frame = frame;
                    [self drawMask:self];
                }
                    break;
                case ScaleTypeLeft:
                {
                    CGRect frame = ges.view.frame;
                    ges.view.frame = [self leftFrameChange:frame trans:trans];
                    [self drawView:ges.view];

                }
                    break;
                case ScaleTypeRight:
                {
                    CGRect frame = ges.view.frame;
                    ges.view.frame = [self rightFrameChange:frame trans:trans];
                    [self drawView:ges.view];

                }
                    break;
                case ScaleTypeTop:
                {
                    CGRect frame = ges.view.frame;
                    ges.view.frame = [self topFrameChange:frame trans:trans];
                    [self drawView:ges.view];
                }
                    break;
                case ScaleTypeBottom:
                {
                    CGRect frame = ges.view.frame;
                    ges.view.frame = [self bottomFrameChange:frame trans:trans];
                    [self drawView:ges.view];
                }
                    break;
                case ScaleTypeLeftTop:
                {
                    CGRect frame = ges.view.frame;
                    frame = [self leftFrameChange:frame trans:trans];
                    frame = [self topFrameChange:frame trans:trans];
                    ges.view.frame = frame;
                    [self drawView:ges.view];
                }
                    break;
                case ScaleTypeRightTop:
                {
                    CGRect frame = ges.view.frame;
                    frame = [self rightFrameChange:frame trans:trans];
                    frame = [self topFrameChange:frame trans:trans];
                    ges.view.frame = frame;
                    [self drawView:ges.view];
                }
                    break;
                case ScaleTypeLeftBottom:
                {
                    CGRect frame = ges.view.frame;
                    frame = [self leftFrameChange:frame trans:trans];
                    frame = [self bottomFrameChange:frame trans:trans];
                    ges.view.frame = frame;
                    [self drawView:ges.view];
                }
                    break;
                case ScaleTypeRightBottom:
                {
                    CGRect frame = ges.view.frame;
                    frame = [self rightFrameChange:frame trans:trans];
                    frame = [self bottomFrameChange:frame trans:trans];
                    ges.view.frame = frame;
                    [self drawView:ges.view];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 拖动过程中的变化
- (CGRect)leftFrameChange:(CGRect)frame trans:(CGPoint)trans {
    frame.origin.x = MAX(0, MIN(startFrame.origin.x + startFrame.size.width - pointWidth, startFrame.origin.x + trans.x));
    frame.size.width = MAX(pointWidth, MIN(startFrame.origin.x + startFrame.size.width, startFrame.size.width - trans.x));
    return frame;
}

- (CGRect)topFrameChange:(CGRect)frame trans:(CGPoint)trans {
    frame.origin.y = MAX(0, MIN(startFrame.origin.y + startFrame.size.height - pointWidth, startFrame.origin.y + trans.y));
    frame.size.height = MAX(pointWidth, MIN(startFrame.origin.y + startFrame.size.height, startFrame.size.height - trans.y));
    return frame;
}

- (CGRect)rightFrameChange:(CGRect)frame trans:(CGPoint)trans {
    frame.size.width = MAX(pointWidth, MIN(self.frame.size.width - frame.origin.x, startFrame.size.width + trans.x));
    return frame;
}

- (CGRect)bottomFrameChange:(CGRect)frame trans:(CGPoint)trans {
    frame.size.height = MAX(pointWidth, MIN(self.frame.size.height - frame.origin.y, startFrame.size.height + trans.y));
    return frame;
}

#pragma mark - 判断滑动或者缩放
ScaleType scaleOrDrag(CGPoint point,UIView *view) {
    
    if (point.x <= edgeOffset) {
        if (point.y <= edgeOffset) {
            return ScaleTypeLeftTop;
        } else if (point.y >= (view.frame.size.height - edgeOffset)) {
            return ScaleTypeLeftBottom;
        } else {
            return ScaleTypeLeft;
        }
    } else if (point.x >= (view.frame.size.width - edgeOffset)) {
        if (point.y <= edgeOffset) {
            return ScaleTypeRightTop;
        } else if (point.y >= (view.frame.size.height - edgeOffset)) {
            return ScaleTypeRightBottom;
        } else {
            return ScaleTypeRight;
        }
    }
    
    if (point.y <= edgeOffset) {
        if (point.x <= edgeOffset) {
            return ScaleTypeLeftTop;
        } else if (point.x >= (view.frame.size.width - edgeOffset)) {
            return ScaleTypeRightTop;
        } else {
            return ScaleTypeTop;
        }
    } else if (point.y >= (view.frame.size.height - edgeOffset)) {
        if (point.x <= edgeOffset) {
            return ScaleTypeRightTop;
        } else if (point.x >= (view.frame.size.width - edgeOffset)) {
            return ScaleTypeRightBottom;
        } else {
            return ScaleTypeBottom;
        }
    }
    return ScaleTypeNone;
    
}


- (void)clipImage:(void(^)(UIImage *image))clip {
    clip([UIImage cutImage:self.image imageViewSize:self.bounds.size clipRect:_cutView.frame]);
}





@end
