//
//  AppDelegate.m
//  TabDemo
//
//  Created by Kevin A. Hoogheem on 2/22/14.
//  Copyright (c) 2014 Kevin A. Hoogheem. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.tabBarController = [[TTTabBarController alloc] init];
	self.tabBarController.delegate = self;
	//[self.tabBarController setDebug:TRUE];

	ViewController *vc1 = [[ViewController alloc] init];
	vc1.view.backgroundColor = [UIColor redColor];
	vc1.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:0];
	
	ViewController *vc2 = [[ViewController alloc] init];
	vc2.view.backgroundColor = [UIColor blueColor];
	vc2.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:0];

	ViewController *vc3 = [[ViewController alloc] init];
	vc3.view.backgroundColor = [UIColor yellowColor];
	vc3.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];

	ViewController *vc4 = [[ViewController alloc] init];
	vc4.view.backgroundColor = [UIColor grayColor];
	vc4.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:0];

	//We need to control the more.. it is no longer auto created
	ViewController *vc5 = [[ViewController alloc] init];
	vc5.view.backgroundColor = [UIColor purpleColor];
	vc5.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:0];

	//[self.tabBarController setViewControllers:@[vc1, vc2, vc3, vc4, vc5]];
	self.tabBarController.viewControllers  = @[vc1, vc2, vc3, vc4, vc5];
	
	[self.tabBarController setSelectedIndex:3];

	NSLog(@"_-_-_-_");
	[self.tabBarController setSelectedViewController:vc1];

	self.window.rootViewController = self.tabBarController;
	[self.window makeKeyAndVisible];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//Delgates
- (BOOL)tabBarController:(TTTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
		
	return TRUE;
}

- (void)tabBarController:(TTTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

	NSLog(@"Selected index: %lu VC: %@", (unsigned long)tabBarController.selectedIndex, viewController);

}
@end
