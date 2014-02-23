//
//  BaseUITabBar.m
//  TabDemo
//
//  Created by Kevin A. Hoogheem on 2/22/14.
//  Copyright (c) 2014 Kevin A. Hoogheem. All rights reserved.
//

#import "BaseUITabBar.h"

@implementation BaseUITabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self setUpColorOfTabBar];
		
    }
    return self;
}

- (void)setUpColorOfTabBar {

	if (IOS7) {
		//iOS7 Specific settings
		self.barTintColor = [UIColor blackColor];
		
	}else {
		
	}
	
	
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
