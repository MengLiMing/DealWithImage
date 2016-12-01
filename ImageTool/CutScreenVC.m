//
//  CutScreenVC.m
//  ImageTool
//
//  Created by my on 2016/11/22.
//  Copyright © 2016年 my. All rights reserved.
//

#import "CutScreenVC.h"

@interface CutScreenVC ()

@property (nonatomic, strong) UIImageView *cutImageV;

@end

@implementation CutScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (UIImageView *)cutImageV {
    if (!_cutImageV) {
        _cutImageV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:_cutImageV];
    }
    return _cutImageV;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIImage cutView:[UIApplication sharedApplication].keyWindow success:^(UIImage *image) {
        self.cutImageV.image = image;
    }];
}


@end
