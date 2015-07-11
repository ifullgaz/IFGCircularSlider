//
//  IFGTimePickerViewController.m
//  IFGCircularSlider
//
//  Created by Eliot Fowler on 12/5/13.
//  Modified by Emmanuel Merali on Jul 12, 2015.
//  Copyright (c) 2015 Emmanuel Merali. All rights reserved.
//

#import "IFGTimePickerViewController.h"
#import "IFGCircularSlider.h"

@interface IFGTimePickerViewController ()

@property (weak, nonatomic) IBOutlet UILabel                *timeLabel;
@property (weak, nonatomic) IBOutlet IFGCircularSlider      *minuteSlider;
@property (weak, nonatomic) IBOutlet IFGCircularSlider      *hourSlider;

@end

@implementation IFGTimePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.minuteSlider.unfilledColor = [UIColor colorWithRed:23/255.0f green:47/255.0f blue:70/255.0f alpha:1.0f];
    self.minuteSlider.filledColor = [UIColor colorWithRed:155/255.0f green:211/255.0f blue:156/255.0f alpha:1.0f];
    [self.minuteSlider setInnerMarkingLabels:@[@"5", @"10", @"15", @"20", @"25", @"30", @"35", @"40", @"45", @"50", @"55", @"0"]];
    self.minuteSlider.labelFont = [UIFont systemFontOfSize:14.0f];
    self.minuteSlider.lineWidth = 8;
    self.minuteSlider.minimumValue = 0;
    self.minuteSlider.maximumValue = 60;
    self.minuteSlider.labelColor = [UIColor colorWithRed:76/255.0f green:111/255.0f blue:137/255.0f alpha:1.0f];
    self.minuteSlider.handleType = CircularSliderHandleTypeDoubleCircleWithOpenCenter;
    self.minuteSlider.handleColor = self.minuteSlider.filledColor;
    
    self.hourSlider.unfilledColor = [UIColor colorWithRed:23/255.0f green:47/255.0f blue:70/255.0f alpha:1.0f];
    self.hourSlider.filledColor = [UIColor colorWithRed:98/255.0f green:243/255.0f blue:252/255.0f alpha:1.0f];
    [self.hourSlider setInnerMarkingLabels:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"]];
    self.hourSlider.snapToLabels = YES;
    self.hourSlider.labelFont = [UIFont systemFontOfSize:14.0f];
    self.hourSlider.lineWidth = 12;
    self.hourSlider.minimumValue = 0;
    self.hourSlider.maximumValue = 12;
    self.hourSlider.labelColor = [UIColor colorWithRed:127/255.0f green:229/255.0f blue:255/255.0f alpha:1.0f];
    self.hourSlider.handleType = CircularSliderHandleTypeBigCircle;
    self.hourSlider.handleColor = self.hourSlider.filledColor;
}

- (IBAction)hourDidChange:(IFGCircularSlider*)slider {
    int newVal = (int)slider.currentValue ? (int)slider.currentValue : 12;
    NSString* oldTime = _timeLabel.text;
    NSRange colonRange = [oldTime rangeOfString:@":"];
    _timeLabel.text = [NSString stringWithFormat:@"%d:%@", newVal, [oldTime substringFromIndex:colonRange.location + 1]];
}

- (IBAction)minuteDidChange:(IFGCircularSlider*)slider {
    int newVal = (int)slider.currentValue < 60 ? (int)slider.currentValue : 0;
    NSString* oldTime = _timeLabel.text;
    NSRange colonRange = [oldTime rangeOfString:@":"];
    _timeLabel.text = [NSString stringWithFormat:@"%@:%02d", [oldTime substringToIndex:colonRange.location], newVal];
}

@end
