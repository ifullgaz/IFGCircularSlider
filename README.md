IFGCircularSlider
================

An extensible circular slider for iOS applications.
Cloned from https://github.com/eliotfowler/EFCircularSlider only because the author doesn't seem to maintain this control anymore.

Installation
------------

The simplest way to use IFGCircularSlider in your application is with [CocoaPods](http://cocoapods.org). See the ["Getting Started" guide for more information](http://guides.cocoapods.org/using/using-cocoapods.html).

#### Podfile

```ruby
platform :ios, '7.0'
pod "IFGCircularSlider", "~> 0.1.0"
```

You could instead clone the project and copy the IFGCircularSlider/*.{h,m} files into your project.


Usage
--------------

In order to add a IFGCircularSlider to your UI, just add a view in storyboard and set the class to IFGCircularSlider.
The valueChanged event is available as for any other control.

Alternatively, a IFGCircularSlider can be added in code:

``` objc
- (void)viewDidLoad {
	...
	CGRect sliderFrame = CGRectMake(110, 150, 100, 100);
    IFGCircularSlider* circularSlider = [[IFGCircularSlider alloc] initWithFrame:sliderFrame];
    [slider addTarget:self action:@selector(newValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:circularSlider];
    ...
}
```

Options
-------

IFGCircularSlider is made to be very easy to style and customize.

###Properties

####minimumValue:(float) - Default: 0.0f

When the slider is at the very top position, it will set the currentValue to this. 

You can set the minimum value with:

```objc
circularSlider.minimumValue = 1.0f;
```

####maximumValue:(float) - Default 100.0f

With IFGCircularSlider, the currentValue increases as you drag the slider clockwise. Therefore, when 
the slider is just to the left of the very top position, it will approach (but never reach) this. 

You can set the maximum value with:

```objc
circularSlider.minimumValue = 100.0f;
```

####currentValue:(float) - Default 0.0f

Whenever the slider changes position, this value will change. It will be a normalized value based on the minimuimValue and maximumValue properties.

You can get the currentValue with:

```objc
float val = circularSlider.currentValue;
```

####lineWidth:(int) - Default 5

This determines the width of the arc that makes up the slider. This will set the value both for the unfilled arc (the background) and the arc that shows how much of the slider has been slid across. **Currently, changing the lineWidth more than a few pixels causes adverse side effects, mainly with the handle.**

You can modify the lineWidth with:

```objc
circularSlider.lineWidth = 6;
```

####handleColor:(UIColor*) - Default [UIColor redColor]

The handle is the part of the slider that you drag with your finger.

Modify the color of the handle with:

```objc
CGFloat hue = ( arc4random() % 256 / 256.0 );
CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;

circularSlider.handleColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
```

####handleType:(IFGHandleType) - Default IFGSemiTransparentWhiteCircle

IFGCircularSlider comes with 5 types of handles:

- CircularSliderHandleTypeSemiTransparentWhiteCircle
- CircularSliderHandleTypeSemiTransparentBlackCircle
- CircularSliderHandleTypeDoubleCircleWithOpenCenter
- CircularSliderHandleTypeDoubleCircleWithClosedCenter
- CircularSliderHandleTypeBigCircle

You can change the handleType with:

```objc
circularSlider.handleType = CircularSliderHandleTypeDoubleCircleWithClosedCenter;
```

####unfilledColor:(UIColor*) - Default [UIColor blackColor]

This is the color that will show if the slider is set to its minimum value.

You can modify the unfilledColor with:

```objc
circularSlider.unfilledColor = [UIColor purpleColor];
```

####filledColor:(UIColor*) - Default [UIColor redColor]

This is the color that will show between the minimum value and the currentValue.

You can modify the filledColor with:

```objc
circularSlider.unfilledColor = [UIColor purpleColor];
```

####labelFont:(UIFont*) - Default [UIFont systemFontOfSize:10.0f]

This is the font that the labels will have if you decide to set inner marking labels (more on this down the page). 

You can modify the labelFont with:

```objc
circularSlider.labelFont = [UIFont systemFontOfSize:14.0f];
```

**Note this will have no effect if you have not passed in the labels that you want to add**

####snapToLabels:(BOOL) - Default NO

If this is set to YES, once finish dragging the slider, it will snap to the closest label and subsequently set the current value to what it would be at that label, not where you dragged it.

You can set the slider to snap to labels with:

```objc
circularSlider.snapToLabels = YES;
```

**Note this will have no effect if you have not passed in the labels that you want to add**

###Functions

####-(void)setInnerMarkingLabels:(NSArray*)labels

You can send this method an array of labels and they will show up on the inside of the slider. There is currently no way to specify the spacing between the labels and therefore they will be evenly spaced out. If you choose to include labels on your slider, you will then have the option to set the font of the label as well as if the slider should snap to the closest label position after the value changes.

The first label will appear at the 12 o'clock position (if it were a clock).

If you wanted to make your slider look like a clock, you would do the following:

```objc
NSArray* hoursArray = @[@"12", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11"];
[circularSlider setInnerMarkingLabels:hoursArray];
``` 

Alarm Clock Demo Design
-----------------------

The alarm clock demo design is an implemented version of a design from Micael Sambora on Dribbble and can be found [here](http://dribbble.com/shots/1293874-AlarmClock-final?list=searches&tag=alarm_clock&offset=102).

More information about Michael Sambora can be found at his [personal website](http://samborek.pl/).

About the developer
-------------------

If you like this control, [follow @EliotFowler](http://www.twitter.com/eliotfowler) on Twitter and let me know!


License (MIT)
-------------

Copyright (c) 2015 Emmanuel Merali

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
