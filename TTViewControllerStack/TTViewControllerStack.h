//
//  TTViewControllerStack.h
//  TTViewControllerStack
//
//  Created by Kevin A. Hoogheem on 1/6/14.
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


@protocol TTViewControllerStackDelegate;

/**
 `TTViewControllerStack` is a container view controller that manages the presentation of a single view controller.
 */
@interface TTViewControllerStack : UIViewController

///---------------------------------------------------------------------------------------
/// @name TTViewControllerStack Properties
///---------------------------------------------------------------------------------------
/**
 Delegate for `TTViewControllerStack`
 
 @see TTViewControllerStackDelegate
*/
@property (nonatomic, assign) id <TTViewControllerStackDelegate> delegate;

/**
 A `NSMutableArray` of `UIViewControllers`
*/
@property (nonatomic, strong) NSMutableArray *viewControllers;

/**
 The currently selected `UIViewController`
*/
@property (nonatomic, readonly) UIViewController *selectedViewController;

/**
 The currently selected Index corresponding to the `UIViewController`
*/
@property (nonatomic, readonly) NSUInteger selectedIndex;

/**
 The duration for optional animation of the view controllers.  Default is set to `0.0f` or no animation of the transition of view controllers.
 
 @see setSelectedIndex:completion:
 @see TTViewControllerStackDelegate ttViewControllerStack:willStartAnimationFrom:toViewController:
 @see TTViewControllerStackDelegate ttViewControllerStack:isAnimatingFrom:toViewController:
*/
@property (nonatomic, assign) CGFloat animationDuration;

/**
 This is set `TRUE` during transition between `UIViewControllers`.  If you don't want interaction while changes are being made you can observe this to set userInteraction on your view.  You can also observe the `TTViewControllerStackDelegate` to determine the transitions.
*/
@property (nonatomic, readonly) BOOL viewControllerTransitioning;


///---------------------------------------------------------------------------------------
/// @name Debuging
///---------------------------------------------------------------------------------------
/**
 Sets Logging of the `TTViewControllerStack`
 
 @param debug Either TRUE or FALSE.  Default is `FALSE`
*/
- (void)setDebug:(BOOL)debug;


///---------------------------------------------------------------------------------------
/// @name ViewController Setup & Tear Down
///---------------------------------------------------------------------------------------

/**
 Sets the Array of viewControllers into the `TTViewControllerStack`
 
 @param viewControllers  A Array of `UIViewControllers`
 @see viewControllers
*/
- (void)setViewControllers:(NSMutableArray *)viewControllers;

/**
 Adds a new `UIViewController` to the `TTViewControllerStack`
 
 @param newController a `UIViewController`
*/
- (void)addViewController:(UIViewController *)newController;

/**
 Removes the `UIViewController` from the `TTViewControllerStack`
 
 @param oldController The `UIViewController` to remove
 @see removeViewControllerAtIndex:
*/
- (void)removeViewController:(UIViewController *)oldController;

/**
 Removes the `UIViewController` from the `TTViewControllerStack` at the specified `index`
 
	You need to make sure your code can handle the changing of the `index`
 
 @param index The index for the `UIViewController` to remove from the `TTViewControllerStack`
 @see removeViewController:
*/
- (void)removeViewControllerAtIndex:(NSUInteger)index;

/**
 Removes all of the `UIViewControllers` from the `TTViewControllerStack`
*/
- (void)removeAllViewControllers;

///---------------------------------------------------------------------------------------
/// @name ViewController Actions
///---------------------------------------------------------------------------------------

/**
 Selects the `UIViewController` based on the `index` passed into it, with an optional completion block
 
 @param index The index of the `UIViewController` you are moving to
 @param completion A block that is run when the method runs.
*/
- (void)setSelectedIndex:(NSUInteger)index completion:(void (^)(void))completion;

/**
 Selects the `UIViewController` based on the `index` passed into it, with an optional completion block
 
 @param index The index of the `UIViewController` you are moving to
*/
- (void)setSelectedIndex:(NSUInteger)index;


/**
 Returns a count of	items in the `TTViewControllerStack`
 
 @return NSInteger A count of items in the stack
*/
- (NSInteger)count;


///---------------------------------------------------------------------------------------
/// @name ViewController Interaction
///---------------------------------------------------------------------------------------

/**
 Toggles the ability for the end user to interact with the `selectedViewController`
 
 @param enabled A BOOL that will set interaction TRUE or FALSE
 @see selectedViewController
*/
- (void)setViewUserInteractionEnabled:(BOOL)enabled;

@end


///---------------------------------------------------------------------------------------
/// @name Delegates
///---------------------------------------------------------------------------------------
/** 
 The `TTViewControllerStack` Delegate Methods
*/
@protocol TTViewControllerStackDelegate <NSObject>

@optional
/**
 Invoked when the `TTViewControllerStack` is about to Change the View Controller.
 
 @param stack  The current `TTViewControllerStack`
 @param viewController  The `UIViewController` which is being selected
 @return BOOL This will either allow or deny the `viewController` from selecting
*/
- (BOOL)ttViewControllerStack:(TTViewControllerStack *)stack shouldSelectViewController:(UIViewController *)viewController;

/**
 Invoked when the `TTViewControllerStack` did Change the View Controller.
 
 @param stack  The current `TTViewControllerStack`
 @param viewController  The `UIViewController` which is being selected
*/
- (void)ttViewControllerStack:(TTViewControllerStack *)stack didSelectViewController:(UIViewController *)viewController;

/////
// Animation Delegation
/////
/**
 Invoked when the `TTViewControllerStack` is about to transition between `fromController` and `toController`.  This is only invoked when the `animationDuration` is greater then `0.0f`
 
 @warning This sets the ViewControllers to a state prior to the animation.
 @param stack The `TTViewControllerStack`
 @param fromController The `UIViewController` that is being transition off screen
 @param toController The `UIViewController` that is being transitioned on screen
 @see ttViewControllerStack:isAnimatingFrom:toViewController:
 */
- (void)ttViewControllerStack:(TTViewControllerStack *)stack willStartAnimationFrom:(UIViewController *)fromController toViewController:(UIViewController *)toController;

/**
 Invoked when the `TTViewControllerStack` is transitioning between `fromController` and `toController`.  This is only invoked when the `animationDuration` is greater then `0.0f`
 
 @warning This is the State of the ViewControllers while animation transition has happened
 @param stack The `TTViewControllerStack`
 @param fromController The `UIViewController` that is being transition off screen
 @param toController The `UIViewController` that is being transitioned on screen
 @see ttViewControllerStack:willStartAnimationFrom:toViewController:
*/
- (void)ttViewControllerStack:(TTViewControllerStack *)stack isAnimatingFrom:(UIViewController *)fromController toViewController:(UIViewController *)toController;


@end

