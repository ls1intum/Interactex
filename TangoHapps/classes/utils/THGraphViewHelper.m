//
//  THGraphViewHelper.c
//  TangoHapps
//
//  Created by Juan Haladjian on 11/02/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#include "THGraphViewHelper.h"
#import "THConstants.h"

CGColorRef CreateDeviceGrayColor(CGFloat w, CGFloat a)
{
	CGColorSpaceRef gray = CGColorSpaceCreateDeviceGray();
	CGFloat comps[] = {w, a};
	CGColorRef color = CGColorCreate(gray, comps);
	CGColorSpaceRelease(gray);
	return color;
}

CGColorRef CreateDeviceRGBColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
{
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat comps[] = {r, g, b, a};
	CGColorRef color = CGColorCreate(rgb, comps);
	CGColorSpaceRelease(rgb);
	return color;
}

CGColorRef graphBackgroundColor()
{
	static CGColorRef c = NULL;
	if (c == NULL)
	{
		c = CreateDeviceGrayColor(0.6, 1.0);
	}
	return c;
}

CGColorRef graphLineColor()
{
	static CGColorRef c = NULL;
	if (c == NULL)
	{
		c = CreateDeviceGrayColor(0.5, 1.0);
	}
	return c;
}

//must call strokeLinez afterwards
void DrawHorizontalLine(CGContextRef context, CGFloat x, CGFloat y, CGFloat width){
    
    CGContextMoveToPoint(context, x, y);
    CGContextAddLineToPoint(context, x + width, y);
}

void StrokeLines(CGContextRef context) {
    
	CGContextSetStrokeColorWithColor(context, graphLineColor());
	CGContextStrokePath(context);
}

void StrokeAllLinesForFrameWithHeight(CGContextRef context, float frameHeight, float lineWidth){
    
	DrawHorizontalLine(context, kGraphViewAxisLabelSize.width, kGraphViewGraphOffsetY + kGraphViewAxisLabelSize.height / 2.0f , lineWidth);
	DrawHorizontalLine(context, kGraphViewAxisLabelSize.width, frameHeight / 2.0f + kGraphViewAxisLabelSize.height / 2.0f, lineWidth);
	DrawHorizontalLine(context, kGraphViewAxisLabelSize.width, frameHeight - kGraphViewGraphOffsetY - kGraphViewAxisLabelSize.height / 2.0f, lineWidth);
    StrokeLines(context);
}
