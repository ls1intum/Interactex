/*
THEditableObjectTests.m
Interactex Designer

Created by Juan Haladjian on 05/11/2012.

Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.). 
www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
www.frizting.org

Martijn ten Bhömer from TU Eindhoven contributed PureData support. Contact: m.t.bhomer@tue.nl.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

#import "THLedEditableObject.h"
#import "THButtonEditableObject.h"
#import "THLabelEditableObject.h"
#import "THiPhoneEditableObject.h"
#import "THiPhoneButtonEditableObject.h"
#import "THLabelEditableObject.h"
#import "THGrouperConditionEditable.h"
#import "THLilypadEditable.h"
#import "THPinEditable.h"
#import "THElementPinEditable.h"
#import "THBoardPinEditable.h"

@interface THEditableObjectTests : GHTestCase {
}
@end

@implementation THEditableObjectTests

//this runs once before all tests
-(void) setUpClass{
    [THTestsHelper startCocos2d];
}

//this runs once after all tests
-(void) tearDownClass{
    
}

//this is called before each test
-(void) setUp{
    
}

//this is called after each test
-(void) tearDown{
    
}
/*
-(void) testConnectionForActionAddedAndRemoved{
    
    World * world = [[THWorldController sharedInstance] newWorld];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [world addClotheObject:led];
    
    THButtonEditableObject * button = [[THButtonEditableObject alloc] init];
    [world addClotheObject:button];
    
    THAction * action = [THTestsHelper registerObject:button invoke:led method:@"turnOn"];
    
    [THTestsHelper startSimulation];
    
    ConnectionLine * connection = [button.connections objectAtIndex:0];
    
    GHAssertTrue(connection.obj2 == led, @"button should be connected to led");
    GHAssertTrue(world.actions.count == 1, @"button should have one action here");
    
    [world deregisterAction:action];
    
    GHAssertTrue(world.actions.count == 0, @"button should have no actions here");
    GHAssertTrue(button.connections.count == 0, @"button should have no connections here");
    
    [THTestsHelper registerObject:button invoke:led method:@"turnOn"];
    
    connection = [button.connections objectAtIndex:0];
    
    GHAssertTrue(connection.obj2 == led, @"button should be connected to led again");
    
    [led removeFromWorld];
    
    GHAssertTrue(button.connections.count == 0, @"button should have no connections since led got destroyed");
}

-(void) testConnectionForActionAddedAndRemovediPhone {
    
    World * world = [[THWorldController sharedInstance] newWorld];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [world addClotheObject:led];
    
    THiPhoneButtonEditableObject * button = [[THiPhoneButtonEditableObject alloc] init];
    [world addiPhoneObject:button];
    
    THAction * action = [THTestsHelper registerObject:button invoke:led method:@"turnOn"];
    
    ConnectionLine * connection = [button.connections objectAtIndex:0];
    
    GHAssertTrue(connection.obj2 == led, @"button should be connected to led");
    GHAssertTrue(world.actions.count == 1, @"button should have one action here");
    
    [world deregisterAction:action];
    
    GHAssertTrue(world.actions.count == 0, @"button should have no actions here");
    GHAssertTrue(button.connections.count == 0, @"button should have no connections here");
    
    [THTestsHelper registerObject:button invoke:led method:@"turnOn"];
    
    connection = [button.connections objectAtIndex:0];
    
    GHAssertTrue(connection.obj2 == led, @"button should be connected to led again");
    
    [led removeFromWorld];
    
    GHAssertTrue(button.connections.count == 0, @"button should have no connections since led got destroyed");
}

-(void) testConnectionForPropertyAddedAndRemoved {
    
    World * world = [[THWorldController sharedInstance] newWorld];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [world addClotheObject:led];
    
    THLabelEditableObject * label = [[THLabelEditableObject alloc] init];
    [world addiPhoneObject:label];
    
    THProperty * property = [[THProperty alloc] initWithName:@"on" andType:kDataTypeBoolean];
    [THTestsHelper registerProperty:property from:led to:label];
    
    ConnectionLine * connection = [led.connections objectAtIndex:0];
    
    GHAssertTrue(connection.obj2 == label, @"led should be connected to label");
    GHAssertTrue(led.actions.count == 1, @"led should have one action here");
    NSMutableArray * actions = [led actionsForProperty:property];
    THAction * action = [actions objectAtIndex:0];
    
    GHAssertEqualObjects(action.target, label.object, @"label should be a viewer of the led");

    [led deregisterAction:action];
    
    GHAssertTrue(led.actions.count == 0, @"led should have no actions here");
    GHAssertTrue(led.connections.count == 0, @"led should have no connections here");
    
    //register the property again
    [THTestsHelper registerProperty:property from:led to:label];
    
    connection = [led.connections objectAtIndex:0];
    GHAssertTrue(connection.obj2 == label, @"led should be connected to label again");
    actions = [led actionsForProperty:property];
    GHAssertTrue(actions.count == 1, @"led should have one viewer here again");
    
    [label removeFromWorld];
    
    GHAssertTrue(led.connections.count == 0, @"led should have no connections since label was destroyed");
    GHAssertTrue(led.actions.count == 0, @"led should have no viewers since label was destroyed");
}

-(void) testConnectionsPersisted {
    
    World * world = [[THWorldController sharedInstance] newWorld];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [world addClotheObject:led];
    
    THSimpleConditionEditableObject * condition = [[THSimpleConditionEditableObject alloc] init];
    [world addCondition:condition];
    
    THProperty * property = [[THProperty alloc] initWithName:@"on" andType:kDataTypeBoolean];
    [THTestsHelper registerProperty:property from:led to:condition];
    
    ConnectionLine * connection = [led.connections objectAtIndex:0];
    
    GHAssertTrue(connection.obj2 == condition, @"condition should be connected to label");
    NSMutableArray * actions = [led actionsForProperty:property];
    GHAssertTrue(actions.count == 1, @"led should have one viewer here");
    THMethodInvokeAction * action = [actions objectAtIndex:0];
    GHAssertTrue(action.target == condition.object, @"condition should be a viewer of the led");
    
    [THTestsHelper startSimulation];
    [THTestsHelper stopSimulation];
    
    world = [THWorldController sharedInstance].currentWorld;
    
    led = [world.clotheObjects objectAtIndex:0];
    condition = [world.conditions objectAtIndex:0];
    
    connection = [led.connections objectAtIndex:0];
    GHAssertTrue(connection.obj2 == condition, @"condition should be connected to label");
    actions = [led actionsForProperty:property];
    GHAssertTrue(actions.count == 1, @"led should have one viewer here");
    THMethodInvokeAction * action2 = [actions objectAtIndex:0];
    GHAssertTrue(action2.target == condition.object, @"condition should be a viewer of the led");
    
    [condition removeFromWorld];
    
    GHAssertTrue(led.connections.count == 0, @"led should have no connections since label was destroyed");
    GHAssertTrue(led.actions.count == 0, @"led should have no actions since label was destroyed");
}


-(void) testConnectionsForGrouperConditionWhenViewableRemoved{
    
    World * world = [[THWorldController sharedInstance] newWorld];
    
    THLedEditableObject * led1 = [[THLedEditableObject alloc] init];
    [world addClotheObject:led1];
    
    THLedEditableObject * led2 = [[THLedEditableObject alloc] init];
    [world addClotheObject:led2];
    
    THLedEditableObject * led3 = [[THLedEditableObject alloc] init];
    [world addClotheObject:led3];
    
    THLedEditableObject * led4 = [[THLedEditableObject alloc] init];
    [world addClotheObject:led4];
    
    THGrouperConditionEditable * condition = [[THGrouperConditionEditable alloc] init];
    [world addCondition:condition];
    
    THProperty * property = [[THProperty alloc] initWithName:@"on" andType:kDataTypeBoolean];
    [THTestsHelper registerProperty:property from:led1 to:condition];
    [THTestsHelper registerProperty:property from:led2 to:condition];
    
    GHAssertTrue(condition.obj1 == led1, @"condition.obj1 should be the led1");
    GHAssertTrue(condition.obj2 == led2, @"condition.obj1 should be the led2");
    
    [THTestsHelper registerProperty:property from:led3 to:condition];
    
    GHAssertTrue(condition.obj1 == led3, @"condition.obj1 should be led3");
    GHAssertTrue(condition.obj2 == nil, @"condition.obj1 should be nil");
    
    
    [THTestsHelper registerProperty:property from:led4 to:condition];
    
    GHAssertTrue(condition.obj2 == led4, @"condition.obj1 should be led4");
    
    [led3 removeFromWorld];
    
    GHAssertTrue(condition.obj1 == nil, @"condition.obj1 should be nil since led3 removed");

}

-(void) testConnectionPropertyConditionCondition{
    
    World * world = [[THWorldController sharedInstance] newWorld];
    
    THGrouperConditionEditable * condition1 = [[THGrouperConditionEditable alloc] init];
    [world addCondition:condition1];
    
    THGrouperConditionEditable * condition2 = [[THGrouperConditionEditable alloc] init];
    [world addCondition:condition2];
    
    THProperty * property = [[THProperty alloc] initWithName:@"isTrue" andType:kDataTypeBoolean];
    
    [THTestsHelper registerProperty:property from:condition1 to:condition2];
    
    GHAssertEquals(condition2.obj1, condition1, @"condition2.obj1 should be the condition1");
    
    [condition1 removeFromWorld];
    
    GHAssertTrue(condition2.obj1 == nil, @"condition2.obj1 should be nil since condition1 removed");
    GHAssertTrue(condition2.connections.count == 0, @"condition2 should have no connections now");
    
    [THTestsHelper registerProperty:property from:condition2 to:condition1];
    
    [THTestsHelper startSimulation];
    [THTestsHelper stopSimulation];
 
    [condition1 removeFromWorld];
    
    
    GHAssertTrue(condition2.obj1 == nil, @"condition2.obj1 should be nil since condition1 removed again");
    GHAssertTrue(condition2.connections.count == 0, @"condition2 should have no connections now since condition1 removed");
}*/

@end
