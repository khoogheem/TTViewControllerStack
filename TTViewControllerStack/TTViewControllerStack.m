//
//  TTViewControllerStack.m
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

#import "TTViewControllerStack.h"
#import "TTArc.h"

#ifndef TTLOG
#define TTLOG(fmt, ...) \
if (self.debug){ \
NSLog((@"%s [%u]: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); \
}
#else
#define TTLOG(...)
#endif

@interface TTViewControllerStack () {
	
}
@property (nonatomic, assign) BOOL debug;

//Otherside for ReadOnly
@property (nonatomic, assign) NSUInteger selectedIndex;		//current selected index
@property (nonatomic, strong) UIViewController *selectedViewController;  //current selectedViewController
@property (nonatomic, assign) BOOL viewControllerTransitioning;

@end


@implementation TTViewControllerStack

- (void)setDebug:(BOOL)debug {
	_debug = debug;
}

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
	_debug = FALSE;
	
	_viewControllers = [[NSMutableArray alloc] init];
	_viewControllerTransitioning = FALSE;
		
	_selectedIndex = 0;
}

- (void)dealloc {
	[super tt_dealloc];

	[_viewControllers tt_release];
}

#pragma mark - View
- (void)viewDidLoad {
	[super viewDidLoad];
	TTLOG(@"View Did load");
	
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	//Select the First ViewController to start
	[self setSelectedIndex:_selectedIndex completion:nil];
}

#pragma mark - ViewControllers
- (void)setViewControllers:(NSMutableArray *)newViewControllers {
	TTLOG(@"Setting Controllers: %@", newViewControllers);
	
	//Protect ourselves here.. we need at least two viewcontrollers to work correctly!!
	//NSAssert([newViewControllers count] >= 2, @"requires at least two view controllers");
	
	//Removed the old Child View Controllers
	for (UIViewController *viewController in self.childViewControllers) {
		[viewController willMoveToParentViewController:nil];
		[viewController removeFromParentViewController];
	}
	
	_viewControllers = [newViewControllers mutableCopy];

	// Add all th new child view controllers.
	for (UIViewController *viewController in _viewControllers) {
		[self addChildViewController:viewController];
		[viewController didMoveToParentViewController:self];
	}
}

- (void)addViewController:(UIViewController *)newController {
	TTLOG(@"Adding ViewController: %@", newController);
	
    [self.viewControllers addObject:newController];

	[self addChildViewController:newController];
	[newController didMoveToParentViewController:self];
}

- (void)removeViewControllerAtIndex:(NSUInteger)index {
	[self removeViewController:self.viewControllers[index]];
}

- (void)removeViewController:(UIViewController *)oldController {
	TTLOG(@"Removing ViewController: %@", oldController);
	
	[self.viewControllers removeObject:oldController];
	
	[oldController willMoveToParentViewController:nil];
	[oldController removeFromParentViewController];
}

- (void)removeAllViewControllers {
	TTLOG(@"Removing all View Controllers");
	
	for (UIViewController *vc in self.viewControllers) {
		[self removeViewController:vc];
	}
}

- (NSInteger)count {
	return [self.viewControllers count];
}

#pragma mark - Change View Controllers
- (void)replaceViewController:(UIViewController *)existingViewController withViewController:(UIViewController *)newViewController inContainerView:(UIView *)containerView animated:(BOOL)animated completion:(void (^)(void))completion {

	//Protection.. Never should be sending nil in for newViewController
	NSParameterAssert(newViewController);
	
	TTLOG(@"Replacing ViewController: %@ with: %@", existingViewController, newViewController);

	//NOW lets Ask The Delegate if we should even move forard!
	if (self.delegate && [self.delegate respondsToSelector:@selector(ttViewControllerStack:shouldSelectViewController:)]) {
		if (![self.delegate ttViewControllerStack:self shouldSelectViewController:newViewController]) {
			return;
		}
	}
	
	void(^internalCompletion)() = ^ {
			
		//Set the new Index
		_selectedIndex = [_viewControllers indexOfObject:newViewController];

		//set the new selected ViewController
		self.selectedViewController = newViewController;
		
		//Tell the delegate we did select a ViewController
		if (self.delegate && [self.delegate respondsToSelector:@selector(ttViewControllerStack:didSelectViewController:)]) {
			[self.delegate ttViewControllerStack:self didSelectViewController:newViewController];
		}
		
		self.viewControllerTransitioning = FALSE;
		
		//perform any completion passed in
        if (completion != nil) completion();
    };

	//Set the newViewController to the same bounds as the ContainerView
	newViewController.view.frame = containerView.bounds;

	//We are about to Transtion so Lets let them know about it.
	self.viewControllerTransitioning = TRUE;
	
	if (existingViewController == newViewController){
		//No existing controller so setup the view with the new one
				
		//this automatically calls view did/will disappear
		[newViewController.view removeFromSuperview];
		
		//this automatically calls view did/will appear
		[containerView addSubview:newViewController.view];
				
		internalCompletion();
		
	}else{
		CGFloat animationDuration = animated ? self.animationDuration : 0;

		
		//Tell the delegate it is starting to animate..
		if (animationDuration != 0) {
			if (self.delegate && [self.delegate respondsToSelector:@selector(ttViewControllerStack:willStartAnimationFrom:toViewController:)]) {
				[self.delegate ttViewControllerStack:self willStartAnimationFrom:existingViewController toViewController:newViewController];
			}
		}

		//During Transition turn off tabbar user interaction
		[self setViewUserInteractionEnabled:FALSE];
		
		[existingViewController willMoveToParentViewController:nil];
		
		[self transitionFromViewController:existingViewController
						  toViewController:newViewController
								  duration:animationDuration
								   options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
								animations:^{
									
									if (animationDuration != 0) {
										//Tell the delegate we want the state for post..
										if (self.delegate && [self.delegate respondsToSelector:@selector(ttViewControllerStack:isAnimatingFrom:toViewController:)]) {
											[self.delegate ttViewControllerStack:self isAnimatingFrom:existingViewController toViewController:newViewController];
										}
									}

								}
								completion:^(BOOL finished){
									[newViewController didMoveToParentViewController:self];
									
									//Allow UserInteraction again
									[self setViewUserInteractionEnabled:TRUE];

									internalCompletion();
								}];
		
	}

}


- (void)setSelectedIndex:(NSUInteger)index completion:(void (^)(void))completion {
	
	//Lets Make sure we are within bounds of the total viewcontrollers
	if (index >= [self.viewControllers count])
		[NSException raise:NSRangeException format:@"***%s: index (%d) beyond bounds (%d)", sel_getName(_cmd), index, [self.viewControllers count] -1];
	
	TTLOG(@"Set Selected: %d", index);
	
	[self replaceViewController:_viewControllers[_selectedIndex] withViewController:_viewControllers[index] inContainerView:self.view  animated:TRUE completion:nil];
	
	TTLOG(@"new index is: %d", self.selectedIndex);

	if (completion != nil) completion();

}

-(void)setSelectedIndex:(NSUInteger)index {
	if (_selectedIndex != index) {
		_selectedIndex = index;
	}
	[self setSelectedIndex:index completion:nil];
}

#pragma mark - User Interaction
- (void)setViewUserInteractionEnabled:(BOOL)enabled {
	
    static NSInteger disableCount;
    if (!enabled) {
        disableCount++;
    } else {
        disableCount = MAX((disableCount - 1), 0);
    }
    self.view.userInteractionEnabled = (disableCount == 0);
}

@end
