//
//  AppDelegate+LifeCycle.m
//  LBYX
//
//  Created by john on 2019/5/31.
//  Copyright © 2019 qt. All rights reserved.
//

#import "AppDelegate+LifeCycle.h"
#import "LeftViewController.h"
#import "HomeController.h"
#import "ChangeLanguageController.h" 
@implementation AppDelegate (LifeCycle)
- (void)registerRootControoler:(NSDictionary *)launchOptions{
    [self setRootController:NO];
    [kNotificationCenter addObserver:self selector:@selector(ChangeLanguage) name:KNotiChaneLanguage object:nil];
}
-(void)setRootController:(BOOL)flag{
    BaseNavigationController *navigationController = [[BaseNavigationController alloc] initWithRootViewController:[HomeController new]];
    self.window.rootViewController = navigationController;
}
-(void)ChangeLanguage{ 
    [self setRootController:YES];
}
@end
