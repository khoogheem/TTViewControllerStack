//
//  ViewController.h
//  TTViewControllerStack
//
//  Created by Kevin A. Hoogheem on 1/6/14.
//  Copyright (c) 2014 Kevin A. Hoogheem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTViewControllerStack.h"

@interface ViewController : UIViewController <TTViewControllerStackDelegate>

@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic, strong) IBOutlet UIButton *addViewButton;
@property (nonatomic, strong) IBOutlet UIButton *removeViewButton;
@property (nonatomic, strong) IBOutlet UISwitch *animationSwitch;

- (IBAction)addnewButtonPressed:(UIButton *)sender;
- (IBAction)removeButtonPressed:(UIButton *)sender;
- (IBAction)animationSwitchChange:(UISwitch *)sender;


@end
