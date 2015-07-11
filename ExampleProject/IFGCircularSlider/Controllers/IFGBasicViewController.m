//
//  IFGBasicViewController.m
//  IFGCircularSlider
//
//  Created by Eliot Fowler on 12/4/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "IFGBasicViewController.h"
#import "IFGCircularSlider.h"

@interface IFGBasicViewController ()

@property (weak, nonatomic) IBOutlet IFGCircularSlider      *circularSlider;
@property (weak, nonatomic) IBOutlet UILabel                *valueLabel;

@end

@implementation IFGBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.circularSlider.currentValue = 10.0f;
}

- (IBAction)valueChanged:(IFGCircularSlider*)slider {
    self.valueLabel.text = [NSString stringWithFormat:@"%.02f", slider.currentValue ];
}

@end
