//
//  WaterImageVC.m
//  ImageTool
//
//  Created by my on 2016/11/22.
//  Copyright © 2016年 my. All rights reserved.
//

#import "WaterImageVC.h"

@interface WaterImageVC ()
{
    NSInteger waterType;
}

@end

@implementation WaterImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (waterType) {
        waterType = 0;
        self.imageView.image = [UIImage waterAtImage:[UIImage imageNamed:@"smile"] waterImgae:[UIImage imageNamed:@"smile"] rect:CGRectMake(10, 10, 30, 30)];
    } else {
        waterType = 1;
        self.imageView.image = [UIImage waterAtImage:[UIImage drawImage:[UIImage imageNamed:@"smile"] size:CGSizeMake(300, 300)] text:@"920459250@qq.com" point:CGPointMake(10, 10) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    }
}



@end
