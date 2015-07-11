//
//  IFGBigLineViewController.m
//  IFGCircularSlider
//
//  Created by Christian Bianciotto on 21/03/14.
//  Copyright (c) 2014 Eliot Fowler. All rights reserved.
//

#import "IFGBigLineViewController.h"
#import "IFGCircularSlider.h"

@interface IFGBigLineViewController ()

@property (weak, nonatomic) IBOutlet IFGCircularSlider      *circularSlider;

@end

@implementation IFGBigLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.circularSlider.lineWidth = 50;
    self.circularSlider.labelFont = [UIFont fontWithName:@"GillSans-Light" size:16];
    NSArray* labels = @[@"B", @"C", @"D", @"E"];
    [self.circularSlider setInnerMarkingLabels:labels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
