//
//  CutImageVC.m
//  ImageTool
//
//  Created by my on 2016/11/22.
//  Copyright © 2016年 my. All rights reserved.
//

#import "CutImageVC.h"
#import "CutImageView.h"

@interface CutImageVC ()
{
    BOOL rule;//是否是规则剪切
    CutImageView *clipImageV;
}
@end

@implementation CutImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = nil;
    self.imageView.backgroundColor = [UIColor redColor];
    self.view.backgroundColor = [UIColor blackColor];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"裁剪" style:UIBarButtonItemStylePlain target:self action:@selector(clipImage)];
    
    clipImageV = [[CutImageView alloc] initWithFrame:CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y + self.imageView.frame.size.height + 20, 300, 300) type:0];
    clipImageV.image = [UIImage imageNamed:@"smile"];
    [self.view addSubview:clipImageV];
    
    
    
//    clipImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y + self.imageView.frame.size.height + 50, 300, 100)];
//    clipImageV.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:clipImageV];
}


- (void)clipImage {
    [clipImageV clipImage:^(UIImage *image) {
        CGRect frame = self.imageView.frame;
        frame.size.height = image.size.height * frame.size.width/image.size.width;
        self.imageView.frame = frame;
        self.imageView.image = image;
    }];
}


//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//    if (rule) {
//        rule = NO;
//        clipImageV.image = [UIImage cutImage:[UIImage imageNamed:@"smile"] imageViewSize:CGSizeMake(300, 300) clipRect:CGRectMake(0, 100, 300, 100)];
//    } else {
//        rule = YES;
//        NSValue *v1 = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
//        NSValue *v2 = [NSValue valueWithCGPoint:CGPointMake(300, 0)];
//        NSValue *v3 = [NSValue valueWithCGPoint:CGPointMake(150, 100)];
//
//        clipImageV.image = [UIImage cutImage:[UIImage imageNamed:@"smile"] imageViewSize:CGSizeMake(300, 300) clipPoints:@[v1,v2,v3]];
//    }
//}

@end
