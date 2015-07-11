//
//  IFGBigCircleHandleViewController.m
//  IFGCircularSlider
//
//  Created by Eliot Fowler on 12/5/13.
//  Modified by Emmanuel Merali on Jul 12, 2015.
//  Copyright (c) 2015 Emmanuel Merali. All rights reserved.
//

#import "IFGBigCircleHandleViewController.h"
#import "IFGCircularSlider.h"

@interface IFGBigCircleHandleViewController ()

@end

@implementation IFGBigCircleHandleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.circularSlider.handleType = CircularSliderHandleTypeBigCircle;
    self.circularSlider.handleColor = [UIColor blueColor];
}

@end
