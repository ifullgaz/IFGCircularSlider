//
//  IFGDemoViewController.m
//  IFGCircularSlider
//
//  Created by Emmanuel Merali on 12/07/2015.
//  Copyright (c) 2015 ifullgaz.com. All rights reserved.
//

#import "IFGDemoViewController.h"

@interface IFGDemoViewController ()

@property (weak, nonatomic) IBOutlet UISlider               *northAngleSlider;
@property (weak, nonatomic) IBOutlet UISlider               *coverageSlider;

@end

@implementation IFGDemoViewController

- (IBAction)northAngleSliderValueChanged:(UISlider *)sender {
    self.circularSlider.northAngle = sender.value;
}

- (IBAction)coverageSliderValueChanged:(UISlider *)sender {
    self.circularSlider.coverage = sender.value;
}

@end
