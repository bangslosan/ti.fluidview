/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiFluidviewView.h"
#import "TiFluidviewViewProxy.h"

@implementation TiFluidviewView

- (void)dealloc
{
    RELEASE_TO_NIL(fluidView);
    [super dealloc];
}

- (BAFluidView*)fluidView
{
    if (fluidView == nil) {
        
        NSNumber *startElevation = [NSNumber numberWithFloat:[TiUtils floatValue:[[self proxy] valueForKey:@"elevation"] def:1.0]];
        fluidView = [[BAFluidView alloc] initWithFrame:[self bounds] startElevation:startElevation];
        [fluidView setAutoresizingMask:UIViewAutoresizingNone];
        
        [self addSubview:fluidView];
    }
    
    return fluidView;
}

- (TiFluidviewViewProxy*)fluidViewProxy
{
    return (TiFluidviewViewProxy*)[self proxy];
}

#pragma mark Public APIs

- (void)setFillColor_:(id)value
{
    ENSURE_TYPE(value, NSString);
    [[self fluidView] setFillColor:[[TiUtils colorValue:value] _color]];
}

- (void)setStrokeColor_:(id)value
{
    ENSURE_TYPE(value, NSString);
    [[self fluidView] setStrokeColor:[[TiUtils colorValue:value] _color]];
}

- (void)setLineWidth_:(id)value
{
    ENSURE_TYPE(value, NSNumber);
    [[self fluidView] setLineWidth:[TiUtils floatValue:value]];
}

- (void)setFillAutoReverse_:(id)value
{
    ENSURE_TYPE(value, NSNumber);
    [[self fluidView] setFillAutoReverse:[TiUtils boolValue:value]];
}

- (void)setFillRepeatCount_:(id)value
{
    ENSURE_TYPE(value, NSNumber);
    [[self fluidView] setFillRepeatCount:[TiUtils floatValue:value]];
}

- (void)setMaxAmplitude_:(id)value
{
    ENSURE_TYPE(value, NSNumber);
    [[self fluidView] setMaxAmplitude:[TiUtils intValue:value]];
}

- (void)setMinAmplitude_:(id)value
{
    ENSURE_TYPE(value, NSNumber);
    [[self fluidView] setMinAmplitude:[TiUtils intValue:value]];
}

- (void)setAmplitudeIncrement_:(id)value
{
    ENSURE_TYPE(value, NSNumber);
    [[self fluidView] setAmplitudeIncrement:[TiUtils intValue:value]];
}

- (void)setFillDuration_:(id)value
{
    ENSURE_TYPE(value, NSNumber);
    [[self fluidView] setFillDuration:[TiUtils doubleValue:value]];
}

#pragma mark Layout utilities

#ifdef TI_USE_AUTOLAYOUT
- (void)initializeTiLayoutView
{
    [super initializeTiLayoutView];
    [self setDefaultHeight:TiDimensionAutoFill];
    [self setDefaultWidth:TiDimensionAutoFill];
}
#endif

#pragma mark Public APIs

- (void)setWidth_:(id)width_
{
    width = TiDimensionFromObject(width_);
    [self updateContentMode];
}

- (void)setHeight_:(id)height_
{
    height = TiDimensionFromObject(height_);
    [self updateContentMode];
}

#pragma mark Layout helper

- (void)updateContentMode
{
    if (self != nil) {
        [self setContentMode:[self contentModeForFluidView]];
    }
}

- (UIViewContentMode)contentModeForFluidView
{
    if (TiDimensionIsAuto(width) || TiDimensionIsAutoSize(width) || TiDimensionIsUndefined(width) ||
        TiDimensionIsAuto(height) || TiDimensionIsAutoSize(height) || TiDimensionIsUndefined(height)) {
        return UIViewContentModeScaleAspectFit;
    } else {
        return UIViewContentModeScaleToFill;
    }
}

- (void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    for (UIView *child in [[self fluidView] subviews]) {
        [TiUtils setView:child positionRect:bounds];
    }
    
    [super frameSizeChanged:frame bounds:bounds];
}

- (CGFloat)contentWidthForWidth:(CGFloat)suggestedWidth
{
    if (autoWidth > 0) {
        //If height is DIP returned a scaled autowidth to maintain aspect ratio
        if (TiDimensionIsDip(height) && autoHeight > 0) {
            return roundf(autoWidth*height.value/autoHeight);
        }
        return autoWidth;
    }
    
    CGFloat calculatedWidth = TiDimensionCalculateValue(width, autoWidth);
    if (calculatedWidth > 0) {
        return calculatedWidth;
    }
    
    return 0;
}

- (CGFloat)contentHeightForWidth:(CGFloat)width_
{
    if (width_ != autoWidth && autoWidth>0 && autoHeight > 0) {
        return (width_*autoHeight/autoWidth);
    }
    
    if (autoHeight > 0) {
        return autoHeight;
    }
    
    CGFloat calculatedHeight = TiDimensionCalculateValue(height, autoHeight);
    if (calculatedHeight > 0) {
        return calculatedHeight;
    }
    
    return 0;
}

- (UIViewContentMode)contentMode
{
    if (TiDimensionIsAuto(width) || TiDimensionIsAutoSize(width) || TiDimensionIsUndefined(width) ||
        TiDimensionIsAuto(height) || TiDimensionIsAutoSize(height) || TiDimensionIsUndefined(height)) {
        return UIViewContentModeScaleAspectFit;
    } else {
        return UIViewContentModeScaleToFill;
    }
}

@end
