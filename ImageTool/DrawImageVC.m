//
//  DrawImageVC.m
//  ImageTool
//
//  Created by my on 2016/11/22.
//  Copyright © 2016年 my. All rights reserved.
//

#import "DrawImageVC.h"

@interface DrawImageVC ()

@end

@implementation DrawImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.imageView.image = nil;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.imageView.image = [UIImage drawImage:[UIImage imageNamed:@"smile"] size:CGSizeMake(10, 10)];
}



@end
