//
//  IFGCircularSlider.m
//  Awake
//
//  Created by Eliot Fowler on 12/3/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "IFGCircularSlider.h"
#import <QuartzCore/QuartzCore.h>
#import "IFGCircularTrig.h"


@interface IFGCircularSlider ()

@property (assign, nonatomic) CGFloat                       radius;
@property (assign, nonatomic) CGFloat                       angleFromNorth;
@property (strong, nonatomic) NSMutableDictionary           *labelsWithPercents;

@property (nonatomic, readonly) CGFloat                     handleWidth;
@property (nonatomic, readonly) CGFloat                     innerLabelRadialDistanceFromCircumference;
@property (nonatomic, readonly) CGPoint                     centerPoint;

@property (nonatomic, readonly) CGFloat                     radiusForDoubleCircleOuterCircle;
@property (nonatomic, readonly) CGFloat                     lineWidthForDoubleCircleOuterCircle;
@property (nonatomic, readonly) CGFloat                     radiusForDoubleCircleInnerCircle;
@property (nonatomic, readonly) CGFloat                     lineWidthForDoubleCircleInnerCircle;

@end

static const CGFloat kFitFrameRadius = -1.0;

@implementation IFGCircularSlider

@synthesize radius = _radius;

#pragma mark - Initialisation
- (instancetype)init {
    return [self initWithRadius:kFitFrameRadius];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultValuesWithRadius:kFitFrameRadius];
    }
    return self;
}

- (instancetype)initWithRadius:(CGFloat)radius {
    self = [self init];
    if (self) {
        [self initDefaultValuesWithRadius:radius];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initDefaultValuesWithRadius:kFitFrameRadius];
    }
    return self;
}

- (void)initDefaultValuesWithRadius:(CGFloat)radius {
    _northAngle    = 0.0;
    _coverage      = 360.0;
    _radius        = radius;
    _maximumValue  = 100.0f;
    _minimumValue  = 0.0f;
    _lineWidth     = 5.0;
    _unfilledColor = [UIColor blackColor];
    _filledColor   = [UIColor redColor];
    _labelFont     = [UIFont systemFontOfSize:10.0f];
    _snapToLabels  = NO;
    _handleType    = CircularSliderHandleTypeSemiTransparentWhiteCircle;
    _labelColor    = [UIColor redColor];
    _labelDisplacement = 0;
    _angleFromNorth = 0.0;
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Public setter overrides

- (void)setNorthAngle:(CGFloat)northAngle {
    _northAngle = northAngle;
    [self setNeedsDisplay];           // Need to redraw
}

- (void)setCoverage:(CGFloat)coverage {
    _coverage = coverage;
    [self setNeedsDisplay];           // Need to redraw
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setNeedsUpdateConstraints]; // This could affect intrinsic content size
    [self invalidateIntrinsicContentSize]; // Need to update intrinsice content size
    [self setNeedsDisplay];           // Need to redraw with new line width
}

- (void)setHandleType:(CircularSliderHandleType)handleType {
    _handleType = handleType;
    [self setNeedsUpdateConstraints]; // This could affect intrinsic content size
    [self setNeedsDisplay];           // Need to redraw with new handle type
}

- (void)setFilledColor:(UIColor*)filledColor {
    _filledColor = filledColor;
    [self setNeedsDisplay]; // Need to redraw with new filled color
}

- (void)setUnfilledColor:(UIColor*)unfilledColor {
    _unfilledColor = unfilledColor;
    [self setNeedsDisplay]; // Need to redraw with new unfilled color
}

- (void)setHandlerColor:(UIColor *)handleColor {
    _handleColor = handleColor;
    [self setNeedsDisplay]; // Need to redraw with new handle color
}

- (void)setLabelFont:(UIFont*)labelFont {
    _labelFont = labelFont;
    [self setNeedsDisplay]; // Need to redraw with new label font
}

- (void)setLabelColor:(UIColor*)labelColor {
    _labelColor = labelColor;
    [self setNeedsDisplay]; // Need to redraw with new label color
}

- (void)setInnerMarkingLabels:(NSArray*)innerMarkingLabels {
    _innerMarkingLabels = innerMarkingLabels;
    [self setNeedsUpdateConstraints]; // This could affect intrinsic content size
    [self setNeedsDisplay]; // Need to redraw with new label texts
}

- (void)setMinimumValue:(CGFloat)minimumValue {
    _minimumValue = minimumValue;
    [self setNeedsDisplay]; // Need to redraw with updated value range
}

- (void)setMaximumValue:(CGFloat)maximumValue {
    _maximumValue = maximumValue;
    [self setNeedsDisplay]; // Need to redraw with updated value range
}

/**
 *  There is no local variable currentValue - it is always calculated based on angleFromNorth
 *
 *  @param currentValue Value used to update angleFromNorth between minimumValue & maximumValue
 */
- (void)setCurrentValue:(CGFloat)currentValue {
    NSAssert(currentValue <= self.maximumValue && currentValue >= self.minimumValue,
             @"currentValue (%.2f) must be between self.minimuValue (%.2f) and self.maximumValue (%.2f)",
              currentValue, self.minimumValue, self.maximumValue);
    
    // Update the angleFromNorth to match this newly set value
    self.angleFromNorth = (currentValue * self.coverage) / (self.maximumValue - self.minimumValue);
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setAngleFromNorth:(CGFloat)angleFromNorth {
    _angleFromNorth = angleFromNorth;
    NSAssert(_angleFromNorth >= 0, @"_angleFromNorth %.2f must be greater than or equal to 0", angleFromNorth);
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    [self invalidateIntrinsicContentSize]; // Need to update intrinsice content size
    [self setNeedsDisplay]; // Need to redraw with new radius
}

#pragma mark - Public getter overrides

/**
 *  There is no local variable currentValue - it is always calculated based on angleFromNorth
 *
 *  @return currentValue Value between minimumValue & maximumValue derived from angleFromNorth
 */
- (CGFloat)currentValue {
    return (self.angleFromNorth * (self.maximumValue - self.minimumValue))/self.coverage;
}

- (CGFloat)radius {
    if (_radius == kFitFrameRadius) {
        // Slider is being used in frames - calculate the max radius based on the frame
        //  (constrained by smallest dimension so it fits within view)
        CGFloat minimumDimension = MIN(self.bounds.size.height, self.bounds.size.width);
        int halfLineWidth = ceilf(self.lineWidth / 2.0);
        int halfHandleWidth = ceilf(self.handleWidth / 2.0);
        return minimumDimension * 0.5 - MAX(halfHandleWidth, halfLineWidth);
    }
    return _radius;
}

- (UIColor*)handleColor {
    UIColor *newHandleColor = _handleColor;
    switch (self.handleType) {
        case CircularSliderHandleTypeSemiTransparentWhiteCircle:
            newHandleColor = [UIColor colorWithWhite:1.0 alpha:0.7];
            break;
        case CircularSliderHandleTypeSemiTransparentBlackCircle:
            newHandleColor = [UIColor colorWithWhite:0.0 alpha:0.7];
            break;
        case CircularSliderHandleTypeDoubleCircleWithClosedCenter:
        case CircularSliderHandleTypeDoubleCircleWithOpenCenter:
        case CircularSliderHandleTypeBigCircle:
            if (!newHandleColor) {
                // handleColor public property hasn't been set - use filledColor
                newHandleColor = self.filledColor;
            }
            break;
    }
    
    return newHandleColor;
}

#pragma mark - Private getter overrides

- (CGFloat)handleWidth {
    switch (self.handleType) {
        case CircularSliderHandleTypeSemiTransparentWhiteCircle:
        case CircularSliderHandleTypeSemiTransparentBlackCircle: {
            return self.lineWidth;
        }
        case CircularSliderHandleTypeBigCircle: {
            return self.lineWidth + 5; // 5 points bigger than standard handles
        }
        case CircularSliderHandleTypeDoubleCircleWithClosedCenter:
        case CircularSliderHandleTypeDoubleCircleWithOpenCenter: {
            return 2 * [IFGCircularTrig outerRadiuOfUnfilledArcWithRadius:self.radiusForDoubleCircleOuterCircle
                                                               lineWidth:self.lineWidthForDoubleCircleOuterCircle];
        }
    }
}

- (CGFloat)radiusForDoubleCircleOuterCircle {
    return 0.5 * self.lineWidth + 5;
}

- (CGFloat)lineWidthForDoubleCircleOuterCircle {
    return 4.0;
}

- (CGFloat)radiusForDoubleCircleInnerCircle {
    return 0.5 * self.lineWidth;
}

- (CGFloat)lineWidthForDoubleCircleInnerCircle {
    return 2.0;
}

- (CGFloat)innerLabelRadialDistanceFromCircumference {
    // Labels should be moved far enough to clear the line itself plus a fixed offset (relative to radius).
    int distanceToMoveInwards  = 0.1 * - (self.radius) - 0.5 * self.lineWidth;
        distanceToMoveInwards -= 0.5 * self.labelFont.pointSize; // Also account for variable font size.
    return distanceToMoveInwards;
}

- (CGPoint)centerPoint {
    return CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
}

#pragma mark - Method overrides
- (CGSize)intrinsicContentSize {
    // Total width is: diameter + (2 * MAX(halfLineWidth, halfHandleWidth))
    int diameter = self.radius * 2;
    int halfLineWidth = ceilf(self.lineWidth / 2.0);
    int halfHandleWidth = ceilf(self.handleWidth / 2.0);
    
    int widthWithHandle = diameter + (2 *  MAX(halfHandleWidth, halfLineWidth));
    
    return CGSizeMake(widthWithHandle, widthWithHandle);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Draw the circular lines that slider handle moves along
    [self drawLine:ctx];
    
    // Draw the draggable 'handle'
    [self drawHandle:ctx];
    
    // Add the labels
    [self drawInnerLabels:ctx];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInsideHandle:point withEvent:event]) {
        return YES; // Point is indeed within handle bounds
    }
    else {
        return [self pointInsideCircle:point withEvent:event]; // Return YES if point is inside slider's circle
    }
}

- (BOOL)pointInsideCircle:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint p1 = [self centerPoint];
    CGPoint p2 = point;
    CGFloat xDist = (p2.x - p1.x);
    CGFloat yDist = (p2.y - p1.y);
    double distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance < self.radius + self.lineWidth * 0.5;
}

- (BOOL)pointInsideHandle:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint handleCenter = [self pointOnCircleAtAngleFromNorth:self.angleFromNorth];
    CGFloat handleRadius = MAX(self.handleWidth, 44.0) * 0.5;
    // Adhere to apple's design guidelines - avoid making touch targets smaller than 44 points
    
    // Treat handle as a box around it's center
    BOOL pointInsideHorzontalHandleBounds = (point.x >= handleCenter.x - handleRadius
                                             && point.x <= handleCenter.x + handleRadius);
    BOOL pointInsideVerticalHandleBounds  = (point.y >= handleCenter.y - handleRadius
                                             && point.y <= handleCenter.y + handleRadius);
    return pointInsideHorzontalHandleBounds && pointInsideVerticalHandleBounds;
}

#pragma mark - Drawing methods

- (void)drawLine:(CGContextRef)ctx {
    // Draw an unfilled circle (this shows what can be filled)
    [self.unfilledColor set];
    [IFGCircularTrig drawUnfilledArcInContext:ctx
                                       center:self.centerPoint
                                       radius:self.radius
                                    lineWidth:self.lineWidth
                           fromAngleFromNorth:self.northAngle
                             toAngleFromNorth:self.northAngle + self.coverage];

    // Draw an unfilled arc up to the currently filled point
    [self.filledColor set];
    [IFGCircularTrig drawUnfilledArcInContext:ctx
                                      center:self.centerPoint
                                      radius:self.radius
                                   lineWidth:self.lineWidth
                          fromAngleFromNorth:self.northAngle
                            toAngleFromNorth:self.northAngle + self.angleFromNorth];
}

- (void)drawHandle:(CGContextRef)ctx{
    CGContextSaveGState(ctx);
    CGPoint handleCenter = [self pointOnCircleAtAngleFromNorth:(self.northAngle + self.angleFromNorth)];
    
    // Ensure that handle is drawn in the correct color
    [self.handleColor set];
    
    switch (self.handleType) {
        case CircularSliderHandleTypeSemiTransparentWhiteCircle:
        case CircularSliderHandleTypeSemiTransparentBlackCircle:
        case CircularSliderHandleTypeBigCircle: {
            [IFGCircularTrig drawFilledCircleInContext:ctx
                                     center:handleCenter
                                     radius:0.5 * self.handleWidth];
            break;
        }
        case CircularSliderHandleTypeDoubleCircleWithClosedCenter:
        case CircularSliderHandleTypeDoubleCircleWithOpenCenter: {
            [self drawUnfilledLineBehindDoubleCircleHandle:ctx];
            
            // Draw unfilled outer circle
            [IFGCircularTrig drawUnfilledCircleInContext:ctx
                                       center:CGPointMake(handleCenter.x,
                                                          handleCenter.y)
                                       radius:self.radiusForDoubleCircleOuterCircle
                                    lineWidth:self.lineWidthForDoubleCircleOuterCircle];
            
            if (self.handleType == CircularSliderHandleTypeDoubleCircleWithClosedCenter) {
                // Draw filled inner circle
                [IFGCircularTrig drawFilledCircleInContext:ctx
                                                   center:handleCenter
                                                   radius:[IFGCircularTrig outerRadiuOfUnfilledArcWithRadius:self.radiusForDoubleCircleInnerCircle
                                                                                                  lineWidth:self.lineWidthForDoubleCircleInnerCircle]];
            }
            else if (self.handleType == CircularSliderHandleTypeDoubleCircleWithOpenCenter) {
                // Draw unfilled inner circle
                [IFGCircularTrig drawUnfilledCircleInContext:ctx
                                                     center:CGPointMake(handleCenter.x,
                                                                        handleCenter.y)
                                                     radius:self.radiusForDoubleCircleInnerCircle
                                                  lineWidth:self.lineWidthForDoubleCircleInnerCircle];
            }
            
            break;
        }
    }
    
    CGContextRestoreGState(ctx);
}

/**
 *  Draw unfilled line from left edge of handle to right edge of handle
 *  This is to ensure that the filled portion of the line doesn't show inside the double circle
 *  @param ctx Graphics Context within which to draw unfilled line behind handle
 */
- (void)drawUnfilledLineBehindDoubleCircleHandle:(CGContextRef)ctx {
    CGFloat degreesToHandleCenter   = self.angleFromNorth;
    // To determine where handle intersects the filledCircle, make approximation that arcLength ~ radius of handle outer circle.
    // This is a fine approximation whenever self.radius is sufficiently large (which it must be for this control to be usable)
    CGFloat degreesDifference = [IFGCircularTrig degreesForArcLength:self.radiusForDoubleCircleOuterCircle
                                                 onCircleWithRadius:self.radius];
    CGFloat degreesToHandleLeftEdge  = degreesToHandleCenter - degreesDifference;
    CGFloat degreesToHandleRightEdge = degreesToHandleCenter + degreesDifference;
    
    CGContextSaveGState(ctx);
    [self.unfilledColor set];
    [IFGCircularTrig drawUnfilledArcInContext:ctx
                                      center:self.centerPoint
                                      radius:self.radius
                                   lineWidth:self.lineWidth
                          fromAngleFromNorth:self.northAngle + degreesToHandleLeftEdge
                            toAngleFromNorth:self.northAngle + degreesToHandleRightEdge];
    CGContextRestoreGState(ctx);
}

- (void)drawInnerLabels:(CGContextRef)ctx {
    // Only draw labels if they have been set
    NSInteger labelsCount = self.innerMarkingLabels.count;
    if(labelsCount) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
        NSDictionary *attributes = @{ NSFontAttributeName: self.labelFont,
                                      NSForegroundColorAttributeName: self.labelColor};
#endif
        for (int i = 0; i < labelsCount; i++) {
            // Enumerate through labels clockwise
            NSString* label = self.innerMarkingLabels[i];
            
            CGRect labelFrame = [self contextCoordinatesForLabelAtIndex:i];
            
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
            [label drawInRect:labelFrame withAttributes:attributes];
#else
            [self.labelColor setFill];
            [label drawInRect:labelFrame withFont:self.labelFont];
#endif
        }
    }
}

- (CGRect)contextCoordinatesForLabelAtIndex:(NSInteger)index {
    NSString *label = self.innerMarkingLabels[index];

    // Determine how many degrees around the full circle this label should go
    // Note that if the coverage is less than a full cirle then
    // We want to label both ends of the arc
    CGFloat percentageRatio = (self.coverage < 360) ? (self.innerMarkingLabels.count - 1) : self.innerMarkingLabels.count;
    CGFloat percentageAlongCircle    = index / percentageRatio;
    CGFloat degreesFromNorthForLabel = percentageAlongCircle * self.coverage + self.northAngle;
    CGPoint pointOnCircle = [self pointOnCircleAtAngleFromNorth:degreesFromNorthForLabel];
    
    CGSize  labelSize        = [self sizeOfString:label withFont:self.labelFont];
    CGPoint offsetFromCircle = [self offsetFromCircleForLabelAtIndex:index withSize:labelSize];

    return CGRectMake(pointOnCircle.x + offsetFromCircle.x, pointOnCircle.y + offsetFromCircle.y, labelSize.width, labelSize.height);
}

- (CGPoint)offsetFromCircleForLabelAtIndex:(NSInteger)index withSize:(CGSize)labelSize {
    // Determine how many degrees around the full circle this label should go
    CGFloat percentageRatio = (self.coverage < 360) ? (self.innerMarkingLabels.count - 1) : self.innerMarkingLabels.count;
    CGFloat percentageAlongCircle    = index / percentageRatio;
    CGFloat degreesFromNorthForLabel = percentageAlongCircle * self.coverage + self.northAngle;
    
    CGFloat radialDistance = self.innerLabelRadialDistanceFromCircumference + self.labelDisplacement;
    CGPoint inwardOffset   = [IFGCircularTrig pointOnRadius:radialDistance
                                            atAngleFromNorth:degreesFromNorthForLabel];
    
    return CGPointMake(-labelSize.width * 0.5 + inwardOffset.x, -labelSize.height * 0.5 + inwardOffset.y);
}

#pragma mark - UIControl functions

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];

    CGPoint lastPoint = [touch locationInView:self];
    [self moveHandle:lastPoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];

    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGPoint lastPoint = [touch locationInView:self];
    [self moveHandle:lastPoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    if (self.snapToLabels && self.innerMarkingLabels != nil) {
        CGPoint bestGuessPoint = CGPointZero;
        CGFloat minDist = self.coverage;
        NSUInteger labelsCount = self.innerMarkingLabels.count;
        CGFloat percentageRatio = (self.coverage < 360) ? (labelsCount - 1) : labelsCount;
        
        for (int i = 0; i < labelsCount; i++) {
            CGFloat percentageAlongCircle = i/percentageRatio;
            CGFloat degreesForLabel = percentageAlongCircle * self.coverage;
            if (fabs(self.angleFromNorth - degreesForLabel) < minDist) {
                minDist = fabs(self.angleFromNorth - degreesForLabel);
                bestGuessPoint = [self pointOnCircleAtAngleFromNorth:degreesForLabel];
            }
        }
        self.angleFromNorth = floor([IFGCircularTrig angleRelativeToNorthFromPoint:self.centerPoint
                                                                             toPoint:bestGuessPoint]);
        [self setNeedsDisplay];
    }
}

- (void)moveHandle:(CGPoint)point {
    self.angleFromNorth = MIN(floor([IFGCircularTrig
                                 angleRelativeToNorthFromPoint:self.centerPoint
                                 toPoint:point
                                 northAngle:self.northAngle]),
                               self.coverage);
    [self setNeedsDisplay];
}

#pragma mark - Helper functions
- (BOOL)isDoubleCircleHandle {
    return self.handleType == CircularSliderHandleTypeDoubleCircleWithClosedCenter || self.handleType == CircularSliderHandleTypeDoubleCircleWithOpenCenter;
}

- (CGSize)sizeOfString:(NSString *)string withFont:(UIFont*)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[NSAttributedString alloc] initWithString:string attributes:attributes].size;
}

- (CGPoint)pointOnCircleAtAngleFromNorth:(int)angleFromNorth {
    CGPoint offset = [IFGCircularTrig pointOnRadius:self.radius atAngleFromNorth:angleFromNorth];
    return CGPointMake(self.centerPoint.x + offset.x, self.centerPoint.y + offset.y);
}

@end
