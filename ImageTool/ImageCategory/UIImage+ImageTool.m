//
//  UIImage+ImageTool.m
//  ImageTool
//
//  Created by my on 2016/11/22.
//  Copyright © 2016年 my. All rights reserved.
//

#import "UIImage+ImageTool.h"

@implementation UIImage (ImageTool)

#pragma mark - 生成图片
+ (UIImage *)createImageColor:(UIColor *)color size:(CGSize)size {
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    //绘制颜色区域
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    [color setFill];
    [path fill];
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(ctx, color.CGColor);
//    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    //从图形上下文获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 绘制图片
+ (UIImage *)drawImage:(UIImage *)image size:(CGSize)size {
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    //绘制图片到图形上下文中
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //从图形上下文获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 缩放
+ (UIImage *)scaleImage:(UIImage *)image sclae:(CGFloat)scale {
    //确定压缩后的size
    CGFloat scaleWidth = image.size.width * scale;
    CGFloat scaleHeight = image.size.height * scale;
    CGSize scaleSize = CGSizeMake(scaleWidth, scaleHeight);
    //开启图形上下文
    UIGraphicsBeginImageContext(scaleSize);
    //绘制图片
    [image drawInRect:CGRectMake(0, 0, scaleWidth, scaleHeight)];
    //从图形上下文获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 水印
//文字水印
+ (UIImage *)waterAtImage:(UIImage *)image
                   text:(NSString *)text
                  point:(CGPoint)point
             attributes:(NSDictionary *)attributes {
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //绘制图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //添加文字
    [text drawAtPoint:point withAttributes:attributes];
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    return newImage;
}

//图片水印
+ (UIImage *)waterAtImage:(UIImage *)image
             waterImgae:(UIImage *)waterImage
                   rect:(CGRect)rect {
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //绘制原图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.width)];
    //绘制水印
    [waterImage drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return newImage;
}

#pragma mark - view快照
+ (void)cutView:(UIView *)view success:(void(^)(UIImage *image))success {
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    //获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //渲染
    [view.layer renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    success(newImage);
}

#pragma mark - 擦除
+ (UIImage *)wipeView:(UIView *)view
                point:(CGPoint)point
                 size:(CGSize)size {
    //开启图形上下文
    UIGraphicsBeginImageContext(view.bounds.size);
    //获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //渲染
    [view.layer renderInContext:ctx];
    //计算擦除的rect
    CGFloat clipX = point.x - size.width/2;
    CGFloat clipY = point.y - size.height/2;
    CGRect clipRect = CGRectMake(clipX, clipY, size.width, size.height);
    //将该区域设置为透明
    CGContextClearRect(ctx, clipRect);
    //获取新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 裁剪
+ (UIImage *)cutImage:(UIImage *)image
        imageViewSize:(CGSize)size
             clipRect:(CGRect)rect {
    //图片大小和实际显示大小的比例
    CGFloat scale_width = image.size.width/size.width;
    CGFloat scale_height = image.size.height/size.height;
    
    //实际剪切区域
    CGRect clipRect = CGRectMake(rect.origin.x * scale_width,
                                 rect.origin.y * scale_height,
                                 rect.size.width * scale_width,
                                 rect.size.height * scale_height);
    
    //开启图形上下文
    UIGraphicsBeginImageContext(clipRect.size);
    //画图
    [image drawAtPoint:CGPointMake(-clipRect.origin.x, -clipRect.origin.y)];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 不规则图形剪裁
+ (UIImage *)cutImage:(UIImage *)image
        imageViewSize:(CGSize)size
           clipPoints:(NSArray *)points {
    //图片大小和实际显示大小的比例
    CGFloat scale_width = image.size.width/size.width;
    CGFloat scale_height = image.size.height/size.height;
    
    //处理剪裁的点
    NSArray *newPoints = [UIImage points:points scalex:scale_width scaleY:scale_height];
    
    //确定上下左右边缘的点
    //x升序数组
    NSArray *point_x = [newPoints sortedArrayUsingComparator:^NSComparisonResult(NSValue *obj1, NSValue *obj2) {
        CGPoint point1 = [obj1 CGPointValue];
        CGPoint point2 = [obj2 CGPointValue];
        return point1.x > point2.x;
    }];
    //y升序数组
    NSArray *point_y = [newPoints sortedArrayUsingComparator:^NSComparisonResult(NSValue *obj1, NSValue *obj2) {
        CGPoint point1 = [obj1 CGPointValue];
        CGPoint point2 = [obj2 CGPointValue];
        return point1.y > point2.y;
    }];
    
    //确定剪切的区域
    CGRect clipRect = CGRectMake([point_x.firstObject CGPointValue].x,
                                 [point_y.firstObject CGPointValue].y,
                                 [point_x.lastObject CGPointValue].x - [point_x.firstObject CGPointValue].x,
                                 [point_y.lastObject CGPointValue].y - [point_y.firstObject CGPointValue].y);
    //开启图形上下文
    UIGraphicsBeginImageContext(clipRect.size);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < newPoints.count; i ++) {
        CGPoint point = [newPoints[i] CGPointValue];
        if (i == 0) {
            [path moveToPoint:point];
        } else {
            [path addLineToPoint:point];
        }
    }
    [path closePath];
    [path addClip];
    
    //画图
    [image drawAtPoint:CGPointMake(-clipRect.origin.x, -clipRect.origin.y)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSArray *)points:(NSArray *)points scalex:(CGFloat)scalex scaleY:(CGFloat)scaley {
    NSMutableArray *newPoints = [NSMutableArray arrayWithCapacity:points.count];
    for (NSInteger i = 0; i < points.count; i ++) {
        CGPoint point = [[points objectAtIndex:i] CGPointValue];
        CGPoint newPoint = CGPointMake(point.x * scalex, point.y * scaley);
        [newPoints addObject:[NSValue valueWithCGPoint:newPoint]];
    }
    return newPoints;
}


+ (UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef),
                                        NULL, false);
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    return [UIImage imageWithCGImage:masked];
}

@end
