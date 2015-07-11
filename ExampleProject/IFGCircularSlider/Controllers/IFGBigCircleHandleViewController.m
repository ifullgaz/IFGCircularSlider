//
//  IFGBigCircleHandleViewController.m
//  IFGCircularSlider
//
//  Created by Eliot Fowler on 12/5/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "IFGBigCircleHandleViewController.h"
#import "IFGCircularSlider.h"

@interface IFGBigCircleHandleViewController ()

@property (weak, nonatomic) IBOutlet IFGCircularSlider      *circularSlider;

@end

@implementation IFGBigCircleHandleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.circularSlider.handleType = CircularSliderHandleTypeBigCircle;
    self.circularSlider.handleColor = [UIColor blueColor];
}

@end
