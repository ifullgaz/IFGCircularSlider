//
//  IFGWithLabelsViewController.m
//  IFGCircularSlider
//
//  Created by Eliot Fowler on 12/5/13.
//  Modified by Emmanuel Merali on Jul 12, 2015.
//  Copyright (c) 2015 Emmanuel Merali. All rights reserved.
//

#import "IFGWithLabelsViewController.h"

@interface IFGWithLabelsViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *snapToLabelsSwitch;

@end

@implementation IFGWithLabelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray* labels = @[@"Beetle", @"Cow", @"Donkey", @"Eagle", @"Ant"];
    self.circularSlider.innerMarkingLabels = labels;
    self.snapToLabelsSwitch.on = NO;
}

- (IBAction)snapToLabelSwitchValueChanged:(UISwitch *)sender {
    self.circularSlider.snapToLabels = sender.on;
}

@end
