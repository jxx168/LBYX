//
//  AppDelegate.h
//  LBYX
//
//  Created by john on 2019/5/31.
//  Copyright © 2019 qt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign, getter=isKeyboardDidShow) BOOL keyboardDidShow;
@end

