//
//  BaseNavigationController.m
//  Dumbbell
//
//  Created by JYS on 16/1/19.
//  Copyright © 2016年 JYS. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad]; 
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.childViewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES ;
        UIButton * btn = [UIButton itemWithRectTarget:self action:@selector(back) image:@"ico_back" title:nil withRect:CGRectMake(0, 0, 44, 44)];
        BaseViewController * base = (BaseViewController *)viewController;
        [base initBarItem:btn withType:0];
    }
    [super pushViewController:viewController animated:YES];
}
 
-(void)back{
    [super popViewControllerAnimated:YES];
}
//设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
