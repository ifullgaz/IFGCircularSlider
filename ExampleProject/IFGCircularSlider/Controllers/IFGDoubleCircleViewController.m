//
//  IFGDoubleCircleViewController.m
//  IFGCircularSlider
//
//  Created by Eliot Fowler on 12/5/13.
//  Modified by Emmanuel Merali on Jul 12, 2015.
//  Copyright (c) 2015 Emmanuel Merali. All rights reserved.
//

#import "IFGDoubleCircleViewController.h"

@interface IFGDoubleCircleViewController ()

@end

@implementation IFGDoubleCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.circularSlider.handleType = CircularSliderHandleTypeDoubleCircleWithOpenCenter;
    self.circularSlider.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
}

@end
