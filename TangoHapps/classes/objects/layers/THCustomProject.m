//
//  THCustomProject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/28/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

#import "THCustomProject.h"
#import "THViewEditableObject.h"
#import "THHardwareComponentEditableObject.h"
#import "THiPhoneEditableObject.h"
#import "THClothe.h"
#import "THLilypadEditable.h"

#import "THClientProject.h"
#import "THConditionEditableObject.h"
#import "THElementPinEditable.h"
#import "THHardwareComponent.h"
#import "THView.h"
#import "THConditionObject.h"
#import "THValue.h"
#import "THValueEditable.h"
#import "THMapperEditable.h"
#import "THMapper.h"
#import "THTriggerEditable.h"
#import "THTrigger.h"
#import "THActionEditable.h"

#import "THElementPin.h"
#import "THLilyPad.h"

#import "THiPhone.h"
#import "THAssetCollection.h"
#import "TFEventActionPair.h"

#import "THBoardPinEditable.h"
#import "THElementPinEditable.h"
#import "THWire.h"

@implementation THCustomProject


#pragma mark - Init

+(id) newProject{
    return [THCustomProject projectNamed:@"New Project"];
}

+(id) projectNamed:(NSString*) name{
    return [[THCustomProject alloc] initWithName:name];
}

-(void) loadCustomProject{
    
    _clothes = [NSMutableArray array];
    _hardwareComponents = [NSMutableArray array];
    _iPhoneObjects = [NSMutableArray array];
    _conditions = [NSMutableArray array];
    _actions = [NSMutableArray array];
    _values = [NSMutableArray array];
    _triggers = [NSMutableArray array];
    
    _wires = [NSMutableArray array];
    
    _assetCollection = [[THAssetCollection alloc] initWithLocalFiles];
}

-(void) initCustomProject{
    
    [self loadCustomProject];
    
    THLilyPadEditable * lilypad = [[THLilyPadEditable alloc] init];
    [self addLilypad:lilypad];
    
    THiPhoneEditableObject * iPhone = [THiPhoneEditableObject iPhoneWithDefaultView];
    iPhone.position = kDefaultiPhonePosition;
    [self addiPhone:iPhone];
}

-(id) init{
    self = [super init];
    if(self){
        [self initCustomProject];
    }
    return self;
}

-(id) initWithName:(NSString*) name{
    self = [super initWithName:name];
    if(self){
        [self initCustomProject];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if(self){
        
        [self loadCustomProject];
        
        THiPhoneEditableObject * iPhone = [decoder decodeObjectForKey:@"iPhone"];
        
        NSArray * clotheObjects = [decoder decodeObjectForKey:@"clotheObjects"];
        NSArray * clothes = [decoder decodeObjectForKey:@"clothes"];
        NSArray * iPhoneObjects = [decoder decodeObjectForKey:@"iPhoneObjects"];
        NSArray * conditions = [decoder decodeObjectForKey:@"conditions"];
        NSArray * values = [decoder decodeObjectForKey:@"values"];
        NSArray * triggers = [decoder decodeObjectForKey:@"triggers"];
        NSArray * actions = [decoder decodeObjectForKey:@"actions"];
        THLilyPadEditable * lilypad = [decoder decodeObjectForKey:@"lilypad"];
        
        NSArray * wires = [decoder decodeObjectForKey:@"wires"];
        
        if(iPhone != nil)
            [self addiPhone:iPhone];
        
        for(THClothe* clothe in clothes){
            [self addClothe:clothe];
        }
        
        for(THHardwareComponentEditableObject* clotheObject in clotheObjects){
            [self addClotheObject:clotheObject];
        }
        
        for(THViewEditableObject* iphoneObject in iPhoneObjects){
            [self addiPhoneObject:iphoneObject];
        }
        
        
        for(TFEditableObject* condition in conditions){
            [self addCondition:condition];
        }
        
        for(TFEditableObject* value in values){
            [self addValue:value];
        }
        
        for(TFEditableObject* trigger in triggers){
            [self addTrigger:trigger];
        }
        
        for(TFEditableObject* action in actions){
            [self addAction:action];
        }
        
        for(THWire * wire in wires){
            [self addWire:wire];
        }
        
        if(lilypad != nil){
            [self addLilypad:lilypad];
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.hardwareComponents forKey:@"clotheObjects"];
    [coder encodeObject:self.clothes forKey:@"clothes"];
    [coder encodeObject:self.iPhoneObjects forKey:@"iPhoneObjects"];
    if(self.iPhone != nil)
        [coder encodeObject:self.iPhone forKey:@"iPhone"];
    [coder encodeObject:self.conditions forKey:@"conditions"];
    [coder encodeObject:self.values forKey:@"values"];
    [coder encodeObject:self.triggers forKey:@"triggers"];
    [coder encodeObject:self.actions forKey:@"actions"];
    [coder encodeObject:self.wires forKey:@"wires"];
    
    if(self.lilypad != nil)
        [coder encodeObject:_lilypad forKey:@"lilypad"];
}

#pragma mark - Pins

//pin
-(void) pinClotheObject:(THHardwareComponentEditableObject*) clotheObject toClothe:(THClothe*) clothe{
    
    if(!clotheObject.attachedToClothe){
        [clothe attachClotheObject:clotheObject];
    }
}

-(void) unpinClotheObject:(THHardwareComponentEditableObject*) clotheObject{
    if(clotheObject.attachedToClothe){
        [clotheObject.attachedToClothe deattachClotheObject:clotheObject];

    }
}

#pragma mark - Lilypad

-(void) addLilypad:(THLilyPadEditable *)lilypad{
    lilypad.position = kLilypadDefaultPosition;
    _lilypad = lilypad;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLilypadAdded object:_lilypad];
}

-(void) removeLilypad{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLilypadRemoved object:_lilypad];
    
    _lilypad = nil;
}

#pragma mark - iPhoneObjects

-(void) addiPhoneObject:(THViewEditableObject*) object{
    if(object.canBeRootView){
        self.iPhone.currentView = object;
    } else {
        [self.iPhone.currentView addSubview:object];
        [_iPhoneObjects addObject:object];
    }
    
    [self notifyObjectAdded:object];
}

-(void) removeiPhoneObject:(THViewEditableObject*) object{
    if(object.canBeRootView){
        self.iPhone.currentView = nil;
    } else {
        [self.iPhone.currentView removeSubview:object];
        [_iPhoneObjects removeObject:object];
    }
    
    [self deregisterActionsForObject:object];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationObjectRemoved object:object];
}

-(THViewEditableObject*) iPhoneObjectAtLocation:(CGPoint) location{
    THViewEditableObject * object = nil;
    for (THViewEditableObject * iPhoneObject in self.iPhoneObjects) {
        if([iPhoneObject testPoint:location]){
            object = iPhoneObject;
        }
    }
    if(!object && [self.iPhone.currentView testPoint:location]){
        object = self.iPhone.currentView;
    }
    return object;
}

#pragma mark - iPhone

-(void) addiPhone:(THiPhoneEditableObject *)iPhone{
    _iPhone = iPhone;
    
    [self notifyObjectAdded:iPhone];
}

-(void) removeiPhone{
    
    [self notifyObjectRemoved:_iPhone];

    _iPhone = nil;
}

#pragma mark - Clothe Objects

-(void) addClotheObject:(THHardwareComponentEditableObject*) clotheObject{
    [self.hardwareComponents addObject:clotheObject];
    [self notifyObjectAdded:clotheObject];
    [self tryAttachClotheObject:clotheObject];
}

-(void) removeClotheObject:(THHardwareComponentEditableObject*) clotheObject{
    [self.hardwareComponents removeObject:clotheObject];

    [self deregisterActionsForObject:clotheObject];
    [self notifyObjectRemoved:clotheObject];
}

-(THHardwareComponentEditableObject*) clotheObjectAtLocation:(CGPoint) location{
    for (THHardwareComponentEditableObject * object in self.hardwareComponents) {
        if([object testPoint:location]){
            return object;
        }
    }
    return nil;
}

-(void) tryAttachClotheObject: (THHardwareComponentEditableObject*) clotheObject{
    if(!clotheObject.attachedToClothe){
        THClothe * clothe = [self clotheAtLocation:clotheObject.position];
        if(clothe){
            [self pinClotheObject:clotheObject toClothe:clothe];
        }
    }
}

#pragma mark - Clothes

-(void) addClothe:(THClothe*) clothe{
    [_clothes addObject:clothe];
    [self notifyObjectAdded:clothe];
}

-(void) removeClothe:(THClothe*) clothe{
    [_clothes removeObject:clothe];
    [self notifyObjectRemoved:clothe];
}

-(THClothe*) clotheAtLocation:(CGPoint) location{
    for (THClothe * clothe in _clothes) {
        if([clothe testPoint:location]){
            return clothe;
        }
    }
    return nil;
}

#pragma mark - Conditions

-(void) addCondition:(TFEditableObject*) condition{
    [_conditions addObject:condition];
    [self notifyObjectAdded:condition];
}

-(void) removeCondition:(TFEditableObject*) condition{
    [_conditions removeObject:condition];
    [self deregisterActionsForObject:condition];
    [self notifyObjectRemoved:condition];
}

-(TFEditableObject*) conditionAtLocation:(CGPoint) location{
    for (TFEditableObject* condition in _conditions) {
        if([condition testPoint:location]){
            return condition;
        }
    }
    return nil;
}

#pragma mark - Values

-(void) addValue:(TFEditableObject*) value{
    [_values addObject:value];
    [self notifyObjectAdded:value];
}

-(void) removeValue:(TFEditableObject*) value{
    [_values removeObject:value];
    [self deregisterActionsForObject:value];
    [self notifyObjectRemoved:value];
}

-(TFEditableObject*) valueAtLocation:(CGPoint) location{
    for (TFEditableObject* value in _values) {
        if([value testPoint:location]){
            return value;
        }
    }
    return nil;
}

#pragma mark - Triggers

-(void) addTrigger:(TFEditableObject*) trigger{
    [_triggers addObject:trigger];
    [self notifyObjectAdded:trigger];
}

-(void) removeTrigger:(TFEditableObject*) trigger{
    [_triggers removeObject:trigger];
    [self deregisterActionsForObject:trigger];
    [self notifyObjectRemoved:trigger];
}

-(TFEditableObject*) triggerAtLocation:(CGPoint) location{
    for (TFEditableObject* trigger in _triggers) {
        if([trigger testPoint:location]){
            return trigger;
        }
    }
    return nil;
}

#pragma mark - Actions

-(void) addAction:(TFEditableObject*) action{
    [_actions addObject:action];
    [self notifyObjectAdded:action];
}

-(void) removeAction:(TFEditableObject*) action{
    [_actions removeObject:action];
    [self deregisterActionsForObject:action];
    [self notifyObjectRemoved:action];
}

-(TFEditableObject*) actionAtLocation:(CGPoint) location{
    for (TFEditableObject* action in _actions) {
        if([action testPoint:location]){
            return action;
        }
    }
    return nil;
}

#pragma mark - Wires

-(void) addWire:(THWire*) wire{
    [self.wires addObject:wire];
    [self notifyObjectAdded:wire];
}

-(void) removeWire:(THWire*) wire{
    [self.wires removeObject:wire];
    
    [self notifyObjectRemoved:wire];
}

-(void) addWireFrom:(THElementPinEditable*) elementPin to:(THBoardPinEditable*) boardPin{
    
    THWire * wire = [[THWire alloc] initWithObj1:elementPin obj2:boardPin];
    
    if(boardPin.type == kPintypeMinus){
        
        wire.color = kMinusPinColor;
        
    } else if(boardPin.type == kPintypePlus){
        
        wire.color = kPlusPinColor;
        
    } else {
        
        wire.color = kWireDefaultColor;
    }
    
    [self addWire:wire];
}

-(void) removeAllWiresTo:(id) object{
    NSMutableArray * toRemove = [NSMutableArray array];
    for (THWire * wire in self.wires) {
        if(wire.obj2 == object){
            [toRemove addObject:wire];
        }
    }
    
    for (id object in toRemove) {
        [self.wires removeObject:object];
    }
}

#pragma mark - All Objects

-(TFEditableObject*) objectAtLocation:(CGPoint)location{
    for (TFEditableObject* object in self.allObjects) {
        if([object testPoint:location]){
            return object;
        }
    }
    if(self.lilypad.parent && [self.lilypad testPoint:location]){
        return self.lilypad;
    }
    
    if(self.iPhone){
        if([self.iPhone.currentView testPoint:location]){
            return self.iPhone.currentView;
        } else if([self.iPhone testPoint:location]){
            return self.iPhone;
        }
    }
    
    //find visible connection
    
    return nil;
}
/*
enum zPositions{
    kLilypadZ = -25,
    kClotheZ = -20,
    kiPhoneZ = -15,
    kClotheObjectZ = -10,
    kValueZ = -9,
    kConditionZ = -8,
    kNormalObjectZ = -7,
};*/

-(NSMutableArray*) allObjects{
    NSMutableArray * allObjects = [NSMutableArray arrayWithArray:self.conditions];
    [allObjects addObjectsFromArray:self.actions];
    [allObjects addObjectsFromArray:self.triggers];
    [allObjects addObjectsFromArray:self.values];
    [allObjects addObjectsFromArray:self.hardwareComponents];
    [allObjects addObjectsFromArray:self.iPhoneObjects];
    [allObjects addObjectsFromArray:self.clothes];
    return allObjects;
}

#pragma Mark - Non Editable Project


-(NSInteger) idxOfSimulable:(TFSimulableObject*) simulable inArray:(NSArray*) array{
    NSInteger i = 0;
    for (TFEditableObject * editable in array) {
        if(editable.simulableObject == simulable){
            return i;
        }
        i++;
    }
    return i;
}

-(NSInteger) idxOfEditable:(TFEditableObject*) editable inArray:(NSArray*) array{
    NSInteger i = 0;
    for (TFEditableObject * e in array) {
        if(e == editable){
            return i;
        }
        i++;
    }
    return i;
}

-(TFSimulableObject*) simulableForEditable:(TFEditableObject*) editable inProject:(THClientProject*) project{
    if([editable isKindOfClass:[THHardwareComponentEditableObject class]]){
        NSInteger idx = [self idxOfEditable:editable inArray:self.hardwareComponents];
        return [project.hardwareComponents objectAtIndex:idx];
    } else if ([editable isKindOfClass:[THViewEditableObject class]]){
        NSInteger idx = [self idxOfEditable:editable inArray:self.iPhoneObjects];
        return [project.iPhoneObjects objectAtIndex:idx];
    } else if ([editable isKindOfClass:[THConditionEditableObject class]]){
        NSInteger idx = [self idxOfEditable:editable inArray:self.conditions];
        return [project.conditions objectAtIndex:idx];
    } else if ([editable isKindOfClass:[THValueEditable class]] || [editable isKindOfClass:[THMapperEditable class]]){
        NSInteger idx = [self idxOfEditable:editable inArray:self.values];
        return [project.values objectAtIndex:idx];
    } else if ([editable isKindOfClass:[THiPhoneEditableObject class]]){
        return (TFSimulableObject*) project.iPhone;
    } else if ([editable isKindOfClass:[THTriggerEditable class]]){
        NSInteger idx = [self idxOfEditable:editable inArray:self.triggers];
        return [project.triggers objectAtIndex:idx];
    } else if ([editable isKindOfClass:[THActionEditable class]]){
        NSInteger idx = [self idxOfEditable:editable inArray:self.actions];
        return [project.actions objectAtIndex:idx];
    } else {
        NSAssert(NO, @"returning nil in simulableForEditable for %@",editable);
        return nil;
    }
}

-(TFSimulableObject*) simulableForSimulable:(TFSimulableObject*) simulable inProject:(THClientProject*) project{
    if([simulable isKindOfClass:[THHardwareComponent class]]){
        NSInteger idx = [self idxOfSimulable:simulable inArray:self.hardwareComponents];
        return [project.hardwareComponents objectAtIndex:idx];
    } else if ([simulable isKindOfClass:[THView class]]){
        NSInteger idx = [self idxOfSimulable:simulable inArray:self.iPhoneObjects];
        return [project.iPhoneObjects objectAtIndex:idx];
    } else if ([simulable isKindOfClass:[THConditionObject class]]){
        NSInteger idx = [self idxOfSimulable:simulable inArray:self.conditions];
        return [project.conditions objectAtIndex:idx];
    } else if ([simulable isKindOfClass:[THValue class]] || [simulable isKindOfClass:[THMapper class]]){
        NSInteger idx = [self idxOfSimulable:simulable inArray:self.values];
        return [project.values objectAtIndex:idx];
    } else if ([simulable isKindOfClass:[THTrigger class]]){
        NSInteger idx = [self idxOfSimulable:simulable inArray:self.triggers];
        return [project.triggers objectAtIndex:idx];
    } else if ([simulable isKindOfClass:[TFAction class]]){
        NSInteger idx = [self idxOfSimulable:simulable inArray:self.actions];
        return [project.triggers objectAtIndex:idx];
    } else {
        NSAssert(NO, @"returning nil in simulableForEditable");
        return nil;
    }
}

-(NSMutableArray*) nonEditableElementsForArray:(NSMutableArray*) objects forProject:(THClientProject*) project{
    NSMutableArray * ret = [NSMutableArray arrayWithCapacity:objects.count];
    
    for (TFEditableObject * object in objects) {
        THSimulableObject * copy = [object.simulableObject copy];
        [ret addObject:copy];
    }
    
    return ret;
}

-(void) addNonEditableActionPairsTo:(THClientProject*) project{
    
    for (TFEventActionPair * pair in self.eventActionPairs) {
        TFMethodInvokeAction * originalAction = (TFMethodInvokeAction*) pair.action;
        
        TFSimulableObject * target = [self simulableForEditable:originalAction.target inProject:project];
        
        TFMethodInvokeAction * action = [[TFMethodInvokeAction alloc] initWithTarget:target method:originalAction.method];
        if(originalAction.firstParam != nil){
            action.firstParam = [originalAction.firstParam copy];
            action.firstParam.target = [self simulableForSimulable:originalAction.firstParam.target inProject:project];
        }
        TFSimulableObject * source = [self simulableForEditable:pair.action.source inProject:project];
        action.source = source;
        
        [project registerAction:action forEvent:pair.event];
    }
}

-(THElementPin*) findElementPin:(THElementPin*) pin inProject:(THClientProject*) project{
    for (THHardwareComponent * clothe in project.hardwareComponents){
        if(pin.hardware == clothe){
            for (THElementPin * epin in clothe.pins){
                if(epin.type == pin.type){
                    return epin;
                }
            }
        }
    }
    return nil;
}

-(void) cleanLilypadPinsFor:(THClientProject*) project{
    //THLilyPad * lilypad = (THLilyPad*) self.lilypad.object;
    
    NSInteger i = 0;
    for (THHardwareComponentEditableObject * editableClothe in self.hardwareComponents){
        THHardwareComponent * clothe = (THHardwareComponent*) editableClothe.simulableObject;
        THHardwareComponent * neclothe = [project.hardwareComponents objectAtIndex:i];
        
        NSInteger j = 0;
        for (THElementPin * epin in clothe.pins){
            if(epin.attachedToPin != nil){
                THElementPin * nepin = [neclothe.pins objectAtIndex:j];
                THBoardPin * lilyPin = (THBoardPin*) epin.attachedToPin;
                
                NSInteger idx = [project.lilypad pinIdxForPin:lilyPin.number ofType:lilyPin.type];
                THBoardPin * newlilyPin = [project.lilypad.pins objectAtIndex:idx];
                
                [newlilyPin attachPin:nepin];
                [nepin attachToPin:newlilyPin];
            }
            j++;
        }
        i++;
    }
    
    /*
     NSInteger i = 0;
     for (THPin * pin in lilypad.pins) {
     THPin * nePin = [world.lilypad.pins objectAtIndex:i];
     if(pin.attachedPins.count > 0){
     NSLog(@"pin %@ has %d attached",nePin,pin.attachedPins.count);
     }
     for (THElementPin * epin in pin.attachedPins) {
     THElementPin * nePinWorld = [self findElementPin:epin inWorld:world];
     [nePin attachPin:nePinWorld];
     }
     i++;
     }*/
}

-(THClientProject*) nonEditableProject{
    THClientProject * project = [[THClientProject alloc] initWithName:self.name];
    project.hardwareComponents = [self nonEditableElementsForArray:self.hardwareComponents forProject:project];
    project.iPhoneObjects = [self nonEditableElementsForArray:self.iPhoneObjects forProject:project];
    project.conditions = [self nonEditableElementsForArray:self.conditions forProject:project];
    project.actions = [self nonEditableElementsForArray:self.actions forProject:project];
    project.values = [self nonEditableElementsForArray:self.values forProject:project];
    project.triggers = [self nonEditableElementsForArray:self.triggers forProject:project];
    project.iPhone = (THiPhone*) self.iPhone.simulableObject;
    project.lilypad = [self.lilypad.simulableObject copy];
    
    [self cleanLilypadPinsFor:project];
    [self addNonEditableActionPairsTo:project];
    
    return project;
}

-(BOOL) isEmpty{
    return (self.allObjects.count == 0);
}

-(TFEditableObject*) editableForSimulable:(TFSimulableObject*) simulable{
    for (TFEditableObject* editable in self.allObjects) {
        if(editable.simulableObject == simulable){
            return editable;
        }
    }
    NSLog(@"warning, simulable not found");
    return nil;
}

-(NSMutableArray*) hardwareProblems{
    NSMutableArray * problems = [NSMutableArray array];
    for (THHardwareComponentEditableObject * clotheObjects in self.hardwareComponents) {
        NSArray * array = clotheObjects.hardwareProblems;
        [problems addObjectsFromArray:array];
    }
    return problems;
}

-(void) prepareToDie{
    
    [super prepareToDie];
    
    [self.iPhone prepareToDie];
    
    for (THWire * wire in self.wires) {
        [wire prepareToDie];
    }

    [self.lilypad prepareToDie];
    
    _iPhone = nil;
}

-(void) willStartSimulation{
    
    [super willStartSimulation];
    
    [self.iPhone willStartSimulation];
}

-(void) didStartSimulation{
    
    [super didStartSimulation];
    
    [self.iPhone didStartSimulation];
}

-(void) prepareForEdition{
    
    [super prepareForEdition];
    
    [self.iPhone willStartEdition];
}

-(NSString*) description{
    return @"CustomProject";
}


@end
