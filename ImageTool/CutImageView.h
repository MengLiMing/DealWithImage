//
//  CutView.h
//  ImageTool
//
//  Created by my on 2016/11/23.
//  Copyright © 2016年 my. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageTool.h"

typedef enum : NSInteger {
    CutImageClipDefault,
    CutImageClipCustom
} CutImageClipType;

@interface CutImageView : UIImageView

@property (nonatomic, assign) CutImageClipType clipType;
@property (nonatomic, strong) UIColor *lineColor;



- (instancetype)initWithFrame:(CGRect)frame type:(CutImageClipType)type;
- (void)clipImage:(void(^)(UIImage *image))clip;

@end
