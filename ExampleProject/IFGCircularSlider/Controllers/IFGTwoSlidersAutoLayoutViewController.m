//
//  IFGTwoSlidersAutoLayoutViewController.m
//  IFGCircularSlider
//
//  Created by Eliot Fowler on 12/5/13.
//  Modified by Emmanuel Merali on Jul 12, 2015.
//  Copyright (c) 2015 Emmanuel Merali. All rights reserved.
//

#import "IFGTwoSlidersAutoLayoutViewController.h"
#import "IFGCircularSlider.h"

@interface IFGTwoSlidersAutoLayoutViewController ()

@property (nonatomic, strong) IBOutlet IFGCircularSlider    *topSlider;
@property (nonatomic, strong) IBOutlet IFGCircularSlider    *bottomSlider;

@end

@implementation IFGTwoSlidersAutoLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topSlider.handleType = CircularSliderHandleTypeDoubleCircleWithOpenCenter;
    self.topSlider.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    
    self.bottomSlider.handleType = CircularSliderHandleTypeDoubleCircleWithOpenCenter;
    self.bottomSlider.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
}

@end
