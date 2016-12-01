//
//  CreateImgaeVC.m
//  ImageTool
//
//  Created by my on 2016/11/22.
//  Copyright © 2016年 my. All rights reserved.
//

#import "CreateImageVC.h"

@interface CreateImageVC ()

@end

@implementation CreateImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.imageView.image = [UIImage createImageColor:[UIColor redColor] size:CGSizeMake(1, 1)];
}

@end
