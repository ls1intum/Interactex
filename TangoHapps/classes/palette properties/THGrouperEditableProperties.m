/*
THGrouperEditableProperties.m
Interactex Designer

Created by Juan Haladjian on 05/10/2013.

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

#import "THGrouperEditableProperties.h"
#import "THGrouperConditionEditable.h"
#import "THGrouperCondition.h"
#import "TFEventActionPair.h"

@implementation THGrouperEditableProperties
@synthesize descriptionLabel;
@synthesize obj2Button;
@synthesize obj1Button;
@synthesize grouperTypeControl;

-(void) reloadState{
    
    [self updateButtonTexts];
    [self updateGrouperType];
    [self updateLabelText];
}

-(NSString *)title
{
    return @"Grouper";
}

-(void) updateLabelText{
    NSString * text = @"";
    
    THGrouperConditionEditable * condition = (THGrouperConditionEditable*) self.editableObject;
    
    THProject * project = [THDirector sharedDirector].currentProject;
    NSArray * actions = [project actionsForSource:condition];
    
    if(condition.obj1 && condition.obj2){
    
        if(actions.count > 0){
            text = @"when ";
            
            if(condition.grouperType == kGrouperTypeOr) {
                text = [text stringByAppendingString:@"either "];
            }
            
            text = [text stringByAppendingString:[self textObject1]];
            
            if(condition.grouperType == kGrouperTypeAnd) {
                text = [text stringByAppendingString:@"and "];
            } else {
                text = [text stringByAppendingString:@"or "];
            }
            
            text = [text stringByAppendingString:[self textObject2]];
            text = [text stringByAppendingString:@"the following actions will happen:\n"];

            BOOL negativeConditions = NO;
            for (TFEventActionPair * pair in actions) {
                if([pair.event.name isEqualToString:kEventConditionIsTrue]){
                    text = [text stringByAppendingFormat:@"- %@\n",pair.action.description];
                } else {
                    negativeConditions = YES;
                }
            }
            
            if(negativeConditions){
                text = [text stringByAppendingString:@"otherwise:\n"];
                for (TFEventActionPair * pair in actions) {
                    if([pair.event.name isEqualToString:kEventConditionIsFalse]){
                        text = [text stringByAppendingFormat:@"- %@\n",pair.action.description];
                    }
                }
            }
            
            text = [text stringByAppendingFormat:@"This will be triggered by either %@ or %@",condition.obj1, condition.obj2];
            
        } else {
            text = @"Conditions set, but actions are missing. Drag a line from the grouper to some other object to add an action";
        }
    
    } else {
        text = @"Conditions are not set";
    }
    
    self.descriptionLabel.text = text;
}

-(void) updateGrouperType{
    
    THGrouperConditionEditable * condition = (THGrouperConditionEditable*) self.editableObject;
    self.grouperTypeControl.selectedSegmentIndex = condition.grouperType;
}

-(NSString*) textObject1{
    
    THGrouperConditionEditable * condition = (THGrouperConditionEditable*) self.editableObject;
    TFEditableObject * object1 = condition.action1.firstParam.target;
    if(condition.action1.firstParam.property.type == kDataTypeInteger || condition.action1.firstParam.property.type == kDataTypeFloat){
        
        return [NSString stringWithFormat:@"%@'s %@ is different than 0 ",object1,condition.propertyName1];
        
    } else {
        
        return [NSString stringWithFormat:@"%@ is %@ ",object1,condition.propertyName1];
    }
}

-(NSString*) textObject2{
    
    THGrouperConditionEditable * condition = (THGrouperConditionEditable*) self.editableObject;
    TFEditableObject * object2 = condition.action2.firstParam.target;
    
    if(condition.action2.firstParam.property.type == kDataTypeInteger || condition.action2.firstParam.property.type == kDataTypeFloat){
        
        return [NSString stringWithFormat:@"%@'s %@ is different than 0 ",object2,condition.propertyName2];
        
    } else {
        return [NSString stringWithFormat:@"%@ is %@ ",object2,condition.propertyName2];
    }
}

-(void) updateButtonTexts{
    THGrouperConditionEditable * condition = (THGrouperConditionEditable*) self.editableObject;
    
    NSString * title = @"";
    
    if(condition.obj1 && condition.propertyName1){
        TFEditableObject * object1 = condition.action1.firstParam.target;
        title = [NSString stringWithFormat:@"%@ (%@)",object1,condition.propertyName1];
        self.obj1Button.enabled = YES;
    } else{
        self.obj1Button.enabled = NO;
    }
    
    [self.obj1Button setTitle:title forState:UIControlStateNormal];
    
    if(condition.obj2 && condition.propertyName2){
        TFEditableObject * object2 = condition.action2.firstParam.target;
        title = [NSString stringWithFormat:@"%@ (%@)",object2,condition.propertyName2];
        self.obj2Button.enabled = YES;
    }else{
        title = @"";
        self.obj2Button.enabled = NO;
    }
    
    [self.obj2Button setTitle:title forState:UIControlStateNormal];
}
/*
-(TFConnectionLine*) createConnectionLineFor:(TFEditableObject*) object{
    
    TFConnectionLine * connection = [TFConnectionLine connectionLine];
    connection.obj1 = (TFEditableObject*)self.editableObject;
    connection.obj2 = object;
    connection.selected = YES;
    
    return connection;
}

-(void) addConnection:(TFConnectionLine*) connection{
    THEditor * editor = (THEditor*) [THDirector sharedDirector].currentLayer;
    [editor addConnectionLine:connection];
}

-(void) removeConnection:(TFConnectionLine*) connection{
    THEditor * editor = (THEditor*) [THDirector sharedDirector].currentLayer;
    [editor removeConnectionLine:connection];
}*/

-(void) updateButton1Selection{
    
    THGrouperConditionEditable * condition = (THGrouperConditionEditable*) self.editableObject;
    
    TFEditableObject * object = condition.action1.firstParam.target;
    
    if(button1Down){
        
        object.highlighted = YES;
        
    } else {
        
        object.highlighted = NO;
    }
}

-(void) updateButton2Selection{
    
    THGrouperConditionEditable * condition = (THGrouperConditionEditable*) self.editableObject;
    
    TFEditableObject * object2 = condition.action2.firstParam.target;
    
    if(button2Down){
        
        object2.highlighted = YES;
        
    } else {
        
        object2.highlighted = NO;
    }
}

- (IBAction)button1Up:(id)sender {
    button1Down = NO;
    [self updateButton1Selection];
}

- (IBAction)button1Down:(id)sender {
    button1Down = YES;
    [self updateButton1Selection];
}

- (IBAction)button2Up:(id)sender {
    button2Down = NO;
    [self updateButton2Selection];
}

- (IBAction)button2Down:(id)sender {
    button2Down = YES;
    [self updateButton2Selection];
}

- (IBAction)grouperTypeChanged:(id)sender {
    
    THGrouperConditionEditable * condition = (THGrouperConditionEditable*) self.editableObject;
    condition.grouperType = self.grouperTypeControl.selectedSegmentIndex;
    [self updateLabelText];
}

- (void)viewDidUnload {
    [self setDescriptionLabel:nil];
    [self setObj1Button:nil];
    [self setObj2Button:nil];
    [self setGrouperTypeControl:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

@end
