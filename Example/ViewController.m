//
//  ViewController.m
//  TTViewControllerStack
//
//  Created by Kevin A. Hoogheem on 1/6/14.
//  Copyright (c) 2014 Kevin A. Hoogheem. All rights reserved.
//

#import "ViewController.h"
#import "SimpleViewController.h"
#import "TTViewControllerStack.h"

@interface ViewController ()

@property (nonatomic, strong) TTViewControllerStack *ttviewStack;
@property (nonatomic, assign) NSInteger vCount;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[_animationSwitch setOn:FALSE];
	
	//lets just create some views...
	SimpleViewController *s1 = [[SimpleViewController alloc] init];
	UINavigationController *nv1 = [[UINavigationController alloc] initWithRootViewController:s1];
	nv1.navigationBar.translucent = FALSE;
	s1.title = @"View 1";
	s1.bkgColor = [UIColor redColor];

	
	SimpleViewController *s2 = [[SimpleViewController alloc] init];
	s2.bkgColor = [UIColor blueColor];
	SimpleViewController *s3 = [[SimpleViewController alloc] init];
	s3.bkgColor = [UIColor yellowColor];
	
	
	_ttviewStack = [[TTViewControllerStack alloc] init];
	_ttviewStack.viewControllers = [NSMutableArray arrayWithObjects:nv1, s2, s3, nil];
	_ttviewStack.delegate = self;
	
	_ttviewStack.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
	[self.containerView addSubview:_ttviewStack.view];
	NSLog(@"FRAME: %@", NSStringFromCGRect(self.containerView.frame));

	
	//Setgmented Control
	NSMutableArray *vA = [[NSMutableArray alloc] init];

	//Fill the Segmented Control with our views
	[_ttviewStack.viewControllers enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[vA addObject:[NSString stringWithFormat:@"V: %d", idx + 1]];
	}];
	
	_segmentControl = [[UISegmentedControl alloc] initWithItems:vA];
	_segmentControl.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 55, CGRectGetWidth(self.view.bounds), 49.0f);
	_segmentControl.tintColor = [UIColor whiteColor];
	//_segmentControl.segmentedControlStyle = UISegmentedControlStylePlain;
	_segmentControl.selectedSegmentIndex = _ttviewStack.selectedIndex;
    [_segmentControl addTarget:self action:@selector(mainSegmentControl:) forControlEvents: UIControlEventValueChanged];
	
	
	[self.view addSubview:_segmentControl];
}


- (IBAction)animationSwitchChange:(UISwitch *)sender {
    if([sender isOn]){
		_ttviewStack.animationDuration = 3.0f;

    } else{
		_ttviewStack.animationDuration = 0.0f;

    }
		
}

- (IBAction)addnewButtonPressed:(UIButton *)sender {
	self.vCount++;
	
	SimpleViewController *s4 = [[SimpleViewController alloc] init];
	s4.bkgColor = [UIColor purpleColor];
	UINavigationController *nv1 = [[UINavigationController alloc] initWithRootViewController:s4];
	nv1.navigationBar.translucent = FALSE;
	s4.title = [NSString stringWithFormat:@"New: %d", self.vCount];
	
	[_ttviewStack addViewController:nv1];
	
	[_segmentControl insertSegmentWithTitle:[NSString stringWithFormat:@"Nv: %d", self.vCount] atIndex:_segmentControl.numberOfSegments +1 animated:FALSE];

}

- (IBAction)removeButtonPressed:(UIButton *)sender {
	
	[_segmentControl removeSegmentAtIndex:0 animated:FALSE];
	[_ttviewStack removeViewControllerAtIndex:0];

}

- (void)mainSegmentControl:(UISegmentedControl *)segment {
//make the changes
	
	[_ttviewStack setSelectedIndex:segment.selectedSegmentIndex completion:^{
		NSLog(@"I just Changed Views via the Segmented Control");
	}];

}

#pragma mark - TTViewControllerStack Delegates

- (BOOL)ttViewControllerStack:(TTViewControllerStack *)ttViewControllerStack shouldSelectViewController:(UIViewController *)viewController {
	
	NSLog(@"ShouldSelectViewController: %@", viewController);
	
	//During Transition don't let them interact with screen
	self.view.userInteractionEnabled = FALSE;
	
	//Just Return True to let it go
	return TRUE;
}

- (void)ttViewControllerStack:(TTViewControllerStack *)ttViewControllerStack didSelectViewController:(UIViewController *)viewController {
	
	NSLog(@"TTViewControllerStack didSelectViewController: %@", viewController);
	
	//OK we can allow user selection again.
	self.view.userInteractionEnabled = TRUE;

}

-(void)ttViewControllerStack:(TTViewControllerStack *)stack willStartAnimationFrom:(UIViewController *)fromController toViewController:(UIViewController *)toController {
	//The Starting Information prior to a animation
	
	NSInteger oldIndex = [stack.viewControllers indexOfObject:fromController];
	NSInteger newIndex = [stack.viewControllers indexOfObject:toController];
	
	
	CGRect rect = self.containerView.bounds;
	if (oldIndex < newIndex){
		rect.origin.x = rect.size.width;
	} else {
		rect.origin.x = -rect.size.width;
	}
	
	toController.view.frame = rect;
	
}

- (void)ttViewControllerStack:(TTViewControllerStack *)stack isAnimatingFrom:(UIViewController *)fromController toViewController:(UIViewController *)toController {
	//The ending position for the animation
	
	NSInteger oldIndex = [stack.viewControllers indexOfObject:fromController];
	NSInteger newIndex = [stack.viewControllers indexOfObject:toController];

	CGRect rect = self.containerView.bounds;
	if (oldIndex < newIndex){
		rect.origin.x = -rect.size.width;
	} else {
		rect.origin.x = rect.size.width;
	}
	fromController.view.frame = rect;
	toController.view.frame = self.containerView.bounds;

	
}

@end
