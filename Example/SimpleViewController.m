//
//  SimpleViewController.m
//  TTViewControllerStack
//
//  Created by Kevin A. Hoogheem on 1/6/14.
//  Copyright (c) 2014 Kevin A. Hoogheem. All rights reserved.
//

#import "SimpleViewController.h"

@interface SimpleViewController ()

@end

@implementation SimpleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.view.backgroundColor = self.bkgColor;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
