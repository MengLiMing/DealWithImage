//
//  WipeViewVC.m
//  ImageTool
//
//  Created by my on 2016/11/22.
//  Copyright © 2016年 my. All rights reserved.
//

#import "WipeViewVC.h"

@interface WipeViewVC ()
{
    UIImageView *topImageV;
}
@end

@implementation WipeViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    topImageV = [[UIImageView alloc] initWithFrame:self.imageView.frame];
    [self.view addSubview:topImageV];
    
    topImageV.image = [UIImage waterAtImage:[UIImage createImageColor:[UIColor redColor] size:CGSizeMake(300, 300)] text:@"滑一下。。。。" point:CGPointMake(20,20) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    topImageV.userInteractionEnabled = YES;
    [topImageV addGestureRecognizer:pan];
}


- (void)pan:(UIPanGestureRecognizer *)pan {
    topImageV.image = [UIImage wipeView:topImageV point:[pan locationInView:topImageV] size:CGSizeMake(30, 30)];
}

@end
