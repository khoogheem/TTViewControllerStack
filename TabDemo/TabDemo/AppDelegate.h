//
//  AppDelegate.h
//  TabDemo
//
//  Created by Kevin A. Hoogheem on 2/22/14.
//  Copyright (c) 2014 Kevin A. Hoogheem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TTTabBarController *tabBarController;

@end
