/*
THComparatorEditableProperties.m
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


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "THComparatorEditableProperties.h"
#import "THComparisonConditionEditable.h"
#import "THComparisonCondition.h"

@implementation THComparatorEditableProperties
@synthesize operatorTypeLabel;
@synthesize object1Button;
@synthesize object2Button;
@synthesize operatorTypeControl;

-(NSString *)title
{
    return @"Comparator";
}

-(NSArray*) selectedConnections{
    NSMutableArray * selectedConnections = [NSMutableArray array];
    if(button1Down){
        [selectedConnections addObject:[NSNumber numberWithInt:0]];
    }
    if(button2Down){
        [selectedConnections addObject:[NSNumber numberWithInt:1]];
    }
    return selectedConnections;
}

-(void) updateOperatorLabel{
    THComparisonConditionEditable * condition = (THComparisonConditionEditable*) self.editableObject;
    
    NSInteger idx = condition.type;
    NSString * conditionString = kConditionTypeStrings[idx];
    self.operatorTypeLabel.text = conditionString;
}

-(void) updateButtons{
    THComparisonConditionEditable * conditionEditable = (THComparisonConditionEditable*) self.editableObject;
    
    NSString * title = @"";
    if(conditionEditable.obj1 == nil){
        self.object1Button.enabled = NO;
    } else {
        title = [NSString stringWithFormat:@"%@ (%@)",conditionEditable.obj1,conditionEditable.propertyName1];
        self.object1Button.enabled = YES;
    }
    
    [self.object1Button setTitle:title forState:UIControlStateNormal];
    
    if(conditionEditable.obj2 == nil){
        title = @"";
        self.object2Button.enabled = NO;
    } else {
        title = [NSString stringWithFormat:@"%@ (%@)",conditionEditable.obj2,conditionEditable.propertyName2];
        self.object2Button.enabled = YES;
    }
    
    [self.object2Button setTitle:title forState:UIControlStateNormal];
}

-(void) updateOperatorType{
    
    THComparisonConditionEditable * condition = (THComparisonConditionEditable*) self.editableObject;
    self.operatorTypeControl.selectedSegmentIndex = condition.type;
}

-(TFConnectionLine*) createConnectionLineFor:(TFEditableObject*) object{
    
    TFConnectionLine * connection = [TFConnectionLine connectionLine];
    connection.obj1 = (TFEditableObject*)self.editableObject;
    connection.obj2 = object;
    connection.selected = YES;
    
    return connection;
}

/*
-(void) addConnection:(TFConnectionLine*) connection{
    TFEditor * editor = (TFEditor*) [THDirector sharedDirector].currentLayer;
    [editor addConnectionLine:connection];
}

-(void) removeConnection:(TFConnectionLine*) connection{
    
    TFEditor * editor = (TFEditor*) [THDirector sharedDirector].currentLayer;
    [editor removeConnectionLine:connection];
}*/

-(void) selectionChanged{
    
    //[Editor sharedInstance].selectedConnections = self.selectedConnections;
    //THComparisonConditionEditable * condition = (THComparisonConditionEditable*) self.editableObject;
    /*
    if(button1Down){
        _connection1 = [self createConnectionLineFor:condition.obj1];
        [self addConnection:_connection1];
    } else {
        [self removeConnection:_connection1];
    }
    
    if(button2Down){
        _connection2 = [self createConnectionLineFor:condition.obj2];
        [self addConnection:_connection2];
    } else {
        [self removeConnection:_connection2];
    }*/
}

- (IBAction)button1Up:(id)sender {
    button1Down = NO;
    [self selectionChanged];
}

- (IBAction)button1Down:(id)sender {
    
    button1Down = YES;
    [self selectionChanged];
}

- (IBAction)button2Up:(id)sender {
    button2Down = NO;
    [self selectionChanged];
}

- (IBAction)button2Down:(id)sender {
    button2Down = YES;
    [self selectionChanged];
}

- (IBAction)operationTypeChanged:(id)sender {
    
    THComparisonConditionEditable * condition = (THComparisonConditionEditable*) self.editableObject;
    
    condition.type = self.operatorTypeControl.selectedSegmentIndex;
    [self updateOperatorLabel];
}

-(void) reloadState{
    [self updateOperatorLabel];
    [self updateButtons];
    [self updateOperatorType];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
}

- (void)viewDidUnload
{
    [self setOperatorTypeLabel:nil];
    [self setObject1Button:nil];
    [self setObject2Button:nil];
    [self setOperatorTypeControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
