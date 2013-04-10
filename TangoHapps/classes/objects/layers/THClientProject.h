//
//  THClientScene.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/25/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

@class THClotheObject;
@class THiPhone;
@class THiPhoneObject;
@class THConditionObject;
@class THLilyPad;

@interface THClientProject : NSObject <NSCoding>
{
}

+(id)emptyProject;

-(void) prepareAllObjectsToDie;

@property (nonatomic, strong) NSMutableArray * clotheObjects;
@property (nonatomic, strong) NSMutableArray * iPhoneObjects;
@property (nonatomic, strong) NSMutableArray * conditions;
@property (nonatomic, strong) NSMutableArray * values;
@property (nonatomic, strong) NSMutableArray * actions;
@property (nonatomic, strong) NSMutableArray * triggers;
@property (nonatomic, strong) THiPhone * iPhone;
@property (nonatomic, strong) THLilyPad * lilypad;

@property (nonatomic, readonly) NSArray * allObjects;

-(void) registerAction:(TFAction*) action forEvent:(TFEvent*) event;

-(void) startSimulating;
-(void) willStartSimulating;
-(void) didStartSimulating;

@end