//
//  IFGSnapToLabelsViewController.m
//  IFGCircularSlider
//
//  Created by Eliot Fowler on 12/5/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "IFGSnapToLabelsViewController.h"
#import "IFGCircularSlider.h"

@interface IFGSnapToLabelsViewController ()

@property (weak, nonatomic) IBOutlet IFGCircularSlider      *circularSlider;

@end

@implementation IFGSnapToLabelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray* labels = @[@"B", @"C", @"D", @"E", @"A"];
    [self.circularSlider setInnerMarkingLabels:labels];
    self.circularSlider.snapToLabels = YES;
}

@end
