//
//  THConditionObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/16/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THConditionObject.h"

@implementation THConditionObject
@dynamic isTrue;

-(void) loadEvents{
    
    TFProperty * property = [TFProperty propertyWithName:@"isTrue" andType:kDataTypeBoolean];
    self.viewableProperties = [NSMutableArray arrayWithObject:property];
    
    TFEvent * event1 = [TFEvent eventNamed:kEventConditionIsTrue];
    TFEvent * event2 = [TFEvent eventNamed:kEventConditionIsFalse];
    TFEvent * event3 = [TFEvent eventNamed:kEventConditionChanged];
    event3.param1 = [TFPropertyInvocation invocationWithProperty:property target:self];
    
    self.events = [NSMutableArray arrayWithObjects:event1,event2,event3, nil];
    
    
    /*
    THMethod * method = [THMethod methodWithName:@"setCondition"];
    method.numParams = 1;
    method.firstParamType = kDataTypeBoolean;
    self.methods = [NSArray arrayWithObject:method];*/
    
}

-(id) init{
    self = [super init];
    if(self){        
        [self loadEvents];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
            
    [self loadEvents];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
}

#pragma mark - Protocols

-(void) evaluateAndTrigger{
    
    if([self testCondition]){
        [self triggerEventNamed:kEventConditionIsTrue];
    } else {
        [self triggerEventNamed:kEventConditionIsFalse];
    }
    
    [self triggerEventNamed:kEventConditionChanged];
}

-(BOOL) isTrue{
    return [self testCondition];
}

-(BOOL) testCondition{
    NSLog(@"warning, testCondition called on THConditionObject");
    return NO;
}

-(NSString*) description{
    return @"conditionAbs";
}

-(void) prepareToDie{
    [super prepareToDie];
}
@end
