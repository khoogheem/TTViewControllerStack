//
//  TTTabBarController.m
//  TabDemo
//
//  Created by Kevin A. Hoogheem on 2/22/14.
//  Copyright (c) 2014 Kevin A. Hoogheem. All rights reserved.
//

#import "TTTabBarController.h"
#import "TTViewControllerStack.h"
#import "BaseUITabBar.h"

//Loging.  Will only NSLog if self.debug is set TRUE
#ifndef TTLOG
#define TTLOG(fmt, ...) \
if (self.debug){ \
NSLog((@"%s [%u]: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); \
}
#else
#define TTLOG(...)
#endif

@interface TTTabBarController () <UITabBarDelegate>

@property (nonatomic, assign) BOOL debug;

//Holds all of the Views for the ContentView (everything above the Tabbar)
@property (nonatomic, retain) TTViewControllerStack *contentViewControllerStack;

//The TabBar
@property (nonatomic, retain) BaseUITabBar *tabBar;

//Views:
@property (nonatomic, strong) UIView *contentView;

@end


@implementation TTTabBarController

- (void)setDebug:(BOOL)debug {
	_debug = debug;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		[self commonInit];
    }
    return self;
}

- (void)commonInit {
	_debug = FALSE;

	self.contentViewControllerStack = [[TTViewControllerStack alloc] init];

	[self.contentViewControllerStack setDebug:FALSE];

	self.tabBar = [[BaseUITabBar alloc] init];
	self.tabBar.delegate = self;

	self.contentView = [[UIView alloc] init];

}

- (void)viewDidLoad {
    [super viewDidLoad];

	[self.tabBar sizeToFit];
	[self.view addSubview:self.tabBar];
	self.tabBar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - self.tabBar.frame.size.height, CGRectGetWidth(self.view.frame), self.tabBar.frame.size.height);
	
	self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;

	[self.view addSubview:self.tabBar];
	
	self.contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - self.tabBar.frame.size.height);
    self.contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

	self.contentViewControllerStack.view.frame = self.contentView.frame;
	
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

	[self.view addSubview:self.contentView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setViewControllers:(NSArray *)viewControllers {
	TTLOG(@"Adding (%d) ViewControllers: %@", viewControllers.count, viewControllers);
	
	//Will cycle the viewControllers and pull out the UITabBarItems out of it
	NSMutableArray *tabBarItems = [NSMutableArray arrayWithCapacity:viewControllers.count];

	for (UIViewController *vc in viewControllers) {
		[tabBarItems addObject:vc.tabBarItem];
	}
	self.tabBar.items = tabBarItems;

	//Remove any old controllers
	[self.contentViewControllerStack removeAllViewControllers];
	
	//Add the ViewControllers to the Stack
	[self.contentViewControllerStack setViewControllers:[NSMutableArray arrayWithArray:viewControllers]];

	//Add the Stack to the contentView
	[self.contentView addSubview:self.contentViewControllerStack.view];

	//Auto select the first Item..
	self.tabBar.selectedItem = tabBarItems[0];
	
	//Use the TabBar Delegate to select the view
	[self.tabBar.delegate tabBar:self.tabBar didSelectItem:tabBarItems[0]];

}

//TabBar Delegate

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	TTLOG(@"Switching to Index: %d", [tabBar.items indexOfObject:item]);
	
	//Tell the Stack which index to move to
	[self.contentViewControllerStack setSelectedIndex:[tabBar.items indexOfObject:item]];
}

@end
