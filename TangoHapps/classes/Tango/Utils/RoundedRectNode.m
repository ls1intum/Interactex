/*
*  RoundedRectNode.m
*
*  Created by John Swensen on 6/2/11.
*  Copyright 2011 swenGames.com.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*
*/

#import "RoundedRectNode.h"

@implementation RoundedRectNode

@synthesize size, radius, borderWidth, cornerSegments, borderColor, fillColor;

#define kappa 0.552228474

-(id) initWithRectSize:(CGSize)sz  {
    self = [super init];
    if(self) {
        size = sz;
        radius = 1;
        borderWidth = 1;
        cornerSegments = 4;
        borderColor = ccc4(255,255,255,255);
        fillColor = ccc4(0,0,0,255);
        
    }
    return self;
}

void appendCubicBezier(int startPoint, CGPoint* vertices, CGPoint origin, CGPoint control1, CGPoint control2, CGPoint destination, NSUInteger segments)
{
	//ccVertex2F vertices[segments + 1];
	
	float t = 0;
	for(NSUInteger i = 0; i < segments; i++)
	{
		GLfloat x = powf(1 - t, 3) * origin.x + 3.0f * powf(1 - t, 2) * t * control1.x + 3.0f * (1 - t) * t * t * control2.x + t * t * t * destination.x;
		GLfloat y = powf(1 - t, 3) * origin.y + 3.0f * powf(1 - t, 2) * t * control1.y + 3.0f * (1 - t) * t * t * control2.y + t * t * t * destination.y;
        vertices[startPoint+i] = CGPointMake(x * CC_CONTENT_SCALE_FACTOR(), y * CC_CONTENT_SCALE_FACTOR() );
		//vertices[startPoint+i] = (ccVertex2F) {x * CC_CONTENT_SCALE_FACTOR(), y * CC_CONTENT_SCALE_FACTOR() };
		t += 1.0f / segments;
	}
	//vertices[segments] = (ccVertex2F) {destination.x * CC_CONTENT_SCALE_FACTOR(), destination.y * CC_CONTENT_SCALE_FACTOR() };
}

void ccFillPoly( CGPoint *poli, int points, BOOL closePolygon )
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_VERTEX_ARRAY,
	// Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY, GL_COLOR_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	
	glVertexPointer(2, GL_FLOAT, 0, poli);
	if( closePolygon )
		//	 glDrawArrays(GL_LINE_LOOP, 0, points);
		glDrawArrays(GL_TRIANGLE_FAN, 0, points);
	else
		glDrawArrays(GL_LINE_STRIP, 0, points);
	
	// restore default state
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}

-(void) draw {
	CGPoint vertices[16];
    
    vertices[0] = ccp(0,-radius);
    vertices[1] = ccp(0,-radius*(1-kappa));
    vertices[2] = ccp(radius*(1-kappa),0);
    vertices[3] = ccp(radius,0);
    
    vertices[4] = ccp(size.width-radius,0);
    vertices[5] = ccp(size.width-radius*(1-kappa),0);
    vertices[6] = ccp(size.width,-radius*(1-kappa));
    vertices[7] = ccp(size.width,-radius);
    
    vertices[8] = ccp(size.width,-size.height + radius);
    vertices[9] = ccp(size.width,-size.height + radius*(1-kappa));
    vertices[10] = ccp(size.width-radius*(1-kappa),-size.height);
    vertices[11] = ccp(size.width-radius,-size.height);
    
    vertices[12] = ccp(radius,-size.height);
    vertices[13] = ccp(radius*(1-kappa),-size.height);                   
    vertices[14] = ccp(0,-size.height+radius*(1-kappa));                   
    vertices[15] = ccp(0,-size.height+radius);    
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    CGPoint polyVertices[4*cornerSegments+1];
    appendCubicBezier(0*cornerSegments,polyVertices,vertices[0], vertices[1], vertices[2], vertices[3], cornerSegments);
    appendCubicBezier(1*cornerSegments,polyVertices,vertices[4], vertices[5], vertices[6], vertices[7], cornerSegments);
    appendCubicBezier(2*cornerSegments,polyVertices,vertices[8], vertices[9], vertices[10], vertices[11], cornerSegments);
    appendCubicBezier(3*cornerSegments,polyVertices,vertices[12], vertices[13], vertices[14], vertices[15], cornerSegments);
    polyVertices[4*cornerSegments] = vertices[0];
    
    glColor4ub(fillColor.r, fillColor.g, fillColor.b, fillColor.a);
    ccFillPoly(polyVertices, 4*cornerSegments+1, YES);
    
    
    glColor4ub(borderColor.r, borderColor.g, borderColor.b, borderColor.a);
    glLineWidth(borderWidth);
    glEnable(GL_LINE_SMOOTH);
    ccDrawCubicBezier(vertices[0], vertices[1], vertices[2], vertices[3], cornerSegments);
    ccDrawLine(vertices[3], vertices[4]);
    ccDrawCubicBezier(vertices[4], vertices[5], vertices[6], vertices[7], cornerSegments);
    ccDrawLine(vertices[7], vertices[8]);
    ccDrawCubicBezier(vertices[8], vertices[9], vertices[10], vertices[11], cornerSegments);
    ccDrawLine(vertices[11], vertices[12]);
    ccDrawCubicBezier(vertices[12], vertices[13], vertices[14], vertices[15], cornerSegments);
    ccDrawLine(vertices[15], vertices[0]);
    glDisable(GL_LINE_SMOOTH);
    
    glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
}

@end