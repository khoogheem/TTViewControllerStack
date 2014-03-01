//
//  TTTabBarController.h
//  TabDemo
//
//  Created by Kevin A. Hoogheem on 2/22/14.
//  Copyright (c) 2014 Kevin A. Hoogheem. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <UIKit/UIKit.h>

@class BaseUITabBar;

@protocol TTTabBarControllerDelegate;

/**
 Drop in replacement for a UITabBarController
*/
@interface TTTabBarController : UIViewController

@property (nonatomic, assign) id <TTTabBarControllerDelegate> delegate;

///---------------------------------------------------------------------------------------
/// @name Managing the View Controllers
///---------------------------------------------------------------------------------------
/**
 An array of the root view controllers displayed by the tab bar interface.  The view controller at index `0` is the left most tabbar item.
*/
@property(nonatomic, copy) NSArray *viewControllers;

/**
 Sets the `viewControllers` which are controlled by the `TTTabBarController`
 
 @param viewControllers An array of ViewControllers
*/
- (void)setViewControllers:(NSArray *)viewControllers;

///---------------------------------------------------------------------------------------
/// @name Managing the Selected Tab
///---------------------------------------------------------------------------------------
/**
 The index of the view controller associated with the currently selected tab item
 
 Default value is NSNotFound
*/
@property (nonatomic) NSUInteger selectedIndex;

/**
 The view controller associated with the currently selected tab item
*/
@property(nonatomic, assign) UIViewController *selectedViewController;

///---------------------------------------------------------------------------------------
/// @name Accessing the Tab Bar Controller Properties
///---------------------------------------------------------------------------------------
/**
 The tab bar view associated with this controller. (read-only)
 
 To configure the items for your tab bar interface, you should assign one or more custom view controllers to the viewControllers property. The tab bar collects the needed tab bar items from the view controllers you specify 
*/
@property (nonatomic, readonly) BaseUITabBar *tabBar;

/**
 A readonly property of the contentView - The portion of the screen where the content is
*/
@property (nonatomic, readonly) UIView *contentView;


///---------------------------------------------------------------------------------------
/// @name Debuging
///---------------------------------------------------------------------------------------
/**
 Sets Logging of the `TTTabBarController`
 
 @param debug Either TRUE or FALSE.  Default is `FALSE`
 */
- (void)setDebug:(BOOL)debug;

@end

///---------------------------------------------------------------------------------------
/// @name Delegates
///---------------------------------------------------------------------------------------
/**
 The `TTTabBarControllerDelegate` Delegate Methods
 */
@protocol TTTabBarControllerDelegate <NSObject>

@optional
/**
 Asks the delegate whether the specified view controller should be made active
 
 @param tabBarController The tab bar controller containing `viewController`
 @param viewController The view controller belonging to the tab that was tapped by the user
 @return BOOL `YES` if the view controller’s tab should be selected or `NO` if the current tab should remain active
*/
- (BOOL)tabBarController:(TTTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;

/**
 Tells the delegate that the user selected an item in the tab bar
 
 @param tabBarController The tab bar controller containing `viewController`
 @param viewController The view controller belonging to the tab that was tapped by the user
*/
- (void)tabBarController:(TTTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end

