//
//  UIImage+ImageTool.h
//  ImageTool
//
//  Created by my on 2016/11/22.
//  Copyright © 2016年 my. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageTool)

///生成图片
+ (UIImage *)createImageColor:(UIColor *)color size:(CGSize)size;
///绘制图片
+ (UIImage *)drawImage:(UIImage *)image size:(CGSize)size;
///缩放
+ (UIImage *)scaleImage:(UIImage *)image sclae:(CGFloat)scale;

/*绘制水印时需要注意，如果原图片的分辨率很高，而显示在视图上的size却很小，则可能添加的水印效果不是你想要的，可以先将图片的size变换后添加水印*/
///文字水印
+ (UIImage *)waterAtImage:(UIImage *)image
                   text:(NSString *)text
                  point:(CGPoint)point
             attributes:(NSDictionary *)attributes;

///图片水印
+ (UIImage *)waterAtImage:(UIImage *)image
             waterImgae:(UIImage *)waterImage
                   rect:(CGRect)rect;


///view快照
+ (void)cutView:(UIView *)view success:(void(^)(UIImage *image))success;


///擦除
+ (UIImage *)wipeView:(UIView *)view point:(CGPoint)point size:(CGSize)size;

///矩形区域裁剪，size是当前image所在imageView的size
+ (UIImage *)cutImage:(UIImage *)image
        imageViewSize:(CGSize)size
             clipRect:(CGRect)rect;

///不规则区域裁剪
+ (UIImage *)cutImage:(UIImage *)image
        imageViewSize:(CGSize)size
           clipPoints:(NSArray *)points;


///特定形状剪切
+ (UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage;

@end
