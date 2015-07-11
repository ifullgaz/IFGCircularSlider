//
//  IFGBasicViewController.m
//  IFGCircularSlider
//
//  Created by Eliot Fowler on 12/4/13.
//  Modified by Emmanuel Merali on Jul 12, 2015.
//  Copyright (c) 2015 Emmanuel Merali. All rights reserved.
//

#import "IFGBasicViewController.h"

@interface IFGBasicViewController ()

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
