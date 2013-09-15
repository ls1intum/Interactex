//
//  THCustomProject.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/28/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

@class THHardwareComponentEditableObject;
@class THiPhoneEditableObject;
@class THViewEditableObject;
@class THClothe;
@class THLilyPadEditable;
@class THiPhoneEditableObject;
@class THClientProject;
@class THAssetCollection;
@class THWire;
@class THElementPinEditable;
@class THBoardPinEditable;
@class THInvocationConnectionLine;

@class TFEditableObject;
@class TFAction;
@class TFEvent;

@interface THCustomProject : NSObject
{
    
}

//static methods
+(BOOL) doesProjectExistWithName:(NSString*) name;
+(NSString*) newProjectName;
+(BOOL) renameProjectNamed:(NSString*) name toName:(NSString*) newName;

//static constructors
+(THCustomProject*) emptyProject;
+(THCustomProject*) projectSavedWithName:(NSString*) name;
+(NSString*) nextProjectNameForName:(NSString*) name;
+(id) newProject;
+(id) projectNamed:(NSString*) name;

//init
-(id) initWithName:(NSString*) name;

//saving and renaming
-(void) save;
-(BOOL) renameTo:(NSString*) newName;

//objects
-(TFEditableObject*) objectAtLocation:(CGPoint) location;

//lifecycle
-(void) willStartSimulation;
-(void) didStartSimulation;
-(void) prepareForEdition;
-(void) prepareToDie;

//actions
-(NSMutableArray*) actionsForTarget:(TFEditableObject*) target;
-(NSMutableArray*) actionsForSource:(TFEditableObject*) source;
-(void) registerAction:(TFAction*) action forEvent:(TFEvent*) event;
-(void) deregisterAction:(TFAction*) action;
-(void) deregisterActionsForObject:(TFEditableObject*) object;

//pin
-(void) pinClotheObject:(THHardwareComponentEditableObject*) clotheObject toClothe:(THClothe*) clothe;
-(void) unpinClotheObject:(THHardwareComponentEditableObject*) clotheObject;

//iPhone
-(void) addiPhone:(THiPhoneEditableObject *)iPhone;
-(void) removeiPhone;

//iPhone objects
-(void) addiPhoneObject:(THViewEditableObject*) object;
-(void) removeiPhoneObject:(THViewEditableObject*) object;
-(THViewEditableObject*) iPhoneObjectAtLocation:(CGPoint) location;

//clotheObjects
-(void) addClotheObject:(THHardwareComponentEditableObject*) clotheObject;
-(void) removeClotheObject:(THHardwareComponentEditableObject*) clotheObject;
-(THHardwareComponentEditableObject*) clotheObjectAtLocation:(CGPoint) location;
-(void) tryAttachClotheObject: (THHardwareComponentEditableObject*) clotheObject;

//clothes
-(void) addClothe:(THClothe*) object;
-(void) removeClothe:(THClothe*) object;
-(THClothe*) clotheAtLocation:(CGPoint) location;

//condition
-(void) addCondition:(TFEditableObject*) condition;
-(void) removeCondition:(TFEditableObject*) condition;
-(TFEditableObject*) conditionAtLocation:(CGPoint) location;

//values
-(void) addValue:(TFEditableObject*) condition;
-(void) removeValue:(TFEditableObject*) condition;
-(TFEditableObject*) valueAtLocation:(CGPoint) location;

//triggers
-(void) addTrigger:(TFEditableObject*) trigger;
-(void) removeTrigger:(TFEditableObject*) trigger;
-(TFEditableObject*) triggerAtLocation:(CGPoint) location;

//actions
-(void) addAction:(TFEditableObject*) action;
-(void) removeAction:(TFEditableObject*) action;
-(TFEditableObject*) actionAtLocation:(CGPoint) location;

//lilypad
-(void) addLilypad:(THLilyPadEditable *)lilypad;
-(void) removeLilypad;

//wires
-(void) addWire:(THWire*) wire;
-(void) removeWire:(THWire*) wire;
-(void) addWireFrom:(THElementPinEditable*) elementPin to:(THBoardPinEditable*) boardPin;
-(void) removeAllWiresTo:(id) object;

//invocation conncetions
-(NSArray*) invocationConnectionsFrom:(TFEditableObject*) obj1 to:(TFEditableObject*) obj2;
-(void) addInvocationConnection:(THInvocationConnectionLine*) connection animated:(BOOL) animated;
-(void) removeInvocationConnection:(THInvocationConnectionLine*) connection;
-(void) removeAllInvocationConnectionsTo:(id) object;
-(void) removeAllConnectionsFrom:(TFEditableObject*) obj1 to:(TFEditableObject*) obj2;

//non editable project
-(THClientProject*) nonEditableProject;

@property (nonatomic,readonly) THLilyPadEditable * lilypad;
@property (nonatomic,readonly) THiPhoneEditableObject * iPhone;
@property (nonatomic,readonly) NSMutableArray * hardwareComponents;
@property (nonatomic,readonly) NSMutableArray * clothes;
@property (nonatomic,readonly) NSMutableArray * iPhoneObjects;
@property (nonatomic,readonly) NSMutableArray * conditions;
@property (nonatomic,readonly) NSMutableArray * values;
@property (nonatomic,readonly) NSMutableArray * triggers;
@property (nonatomic,readonly) NSMutableArray * actions;
@property (nonatomic, readonly) NSMutableArray * wires;
@property (nonatomic, readonly) NSMutableArray * invocationConnections;

@property (nonatomic, readonly) NSArray * allObjects;
@property (nonatomic, readonly) NSMutableArray * eventActionPairs;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, readonly) BOOL isEmpty;

@property (nonatomic,readonly) THAssetCollection * assetCollection;

@end
