/*
 * TangoFramework
 *
 * Copyright (c) 2012 Juan Haladjian
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
 */

#import <Foundation/Foundation.h>

@class TFEditableObject;
@class TFAction;
@class TFEvent;

@interface TFProject : NSObject <NSCoding>
{
}

@property (nonatomic, readonly) NSArray * allObjects;
@property (nonatomic, readonly) NSMutableArray * eventActionPairs;
@property (nonatomic, copy) NSString * name;
@property (nonatomic) BOOL isEmpty;

//statis methods
+(TFProject*)emptyProject;
+(TFProject*) projectSavedWithName:(NSString*) name;

//init
-(id) initWithName:(NSString*) name;
-(void) save;

//objects
-(TFEditableObject*) objectAtLocation:(CGPoint) location;
-(void) notifyObjectAdded:(TFEditableObject*) object;
-(void) notifyObjectRemoved:(TFEditableObject*) object;

//actions
-(NSMutableArray*) actionsForTarget:(TFEditableObject*) target;
-(NSMutableArray*) actionsForSource:(TFEditableObject*) source;
-(void) registerAction:(TFAction*) action forEvent:(TFEvent*) event;
-(void) deregisterAction:(TFAction*) action;
-(void) deregisterActionsForObject:(TFEditableObject*) object;

//lifecycle
-(void) willStartSimulation;
-(void) didStartSimulation;
-(void) prepareForEdition;
-(void) prepareToDie;

@end