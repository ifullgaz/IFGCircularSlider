//
//  IFGDoubleCircleViewController.m
//  IFGCircularSlider
//
//  Created by Eliot Fowler on 12/5/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "IFGDoubleCircleViewController.h"
#import "IFGCircularSlider.h"

@interface IFGDoubleCircleViewController ()

@property (weak, nonatomic) IBOutlet IFGCircularSlider      *circularSlider;

@end

@implementation IFGDoubleCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.circularSlider.handleType = CircularSliderHandleTypeDoubleCircleWithOpenCenter;
    self.circularSlider.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
}

@end
