//
//  THGrouperEditableProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THGrouperEditableProperties.h"
#import "THGrouperConditionEditable.h"
#import "THGrouperCondition.h"

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
    
    TFProject * project = [TFDirector sharedDirector].currentProject;
    NSArray * actions = [project actionsForSource:condition];
    
    if(condition.obj1 && condition.obj2){
    
        if(actions.count > 0){
            text = @"when ";
            
            if(condition.type == kGrouperTypeOr) {
                text = [text stringByAppendingString:@"either "];
            }
            
            text = [text stringByAppendingString:[self textObject1]];
            
            if(condition.type == kGrouperTypeAnd) {
                text = [text stringByAppendingString:@"and "];
            } else {
                text = [text stringByAppendingString:@"or "];
            }
            
            text = [text stringByAppendingString:[self textObject2]];
            text = [text stringByAppendingString:@":\n"];

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
            
        } else {
            text = @"Conditions set, but actions not set yet";
        }
    
    } else {
        text = @"Conditions are not set and therefore nothing will happen";
    }
    
    self.descriptionLabel.text = text;
}

-(void) updateGrouperType{
    
    THGrouperConditionEditable * condition = (THGrouperConditionEditable*) self.editableObject;
    self.grouperTypeControl.selectedSegmentIndex = condition.type;
}

-(NSString*) textObject1{
    
    THGrouperConditionEditable * condition = (THGrouperConditionEditable*) self.editableObject;
    return [NSString stringWithFormat:@"%@ is %@ ",condition.obj1,condition.propertyName1];
}

-(NSString*) textObject2{
    
    THGrouperConditionEditable * condition = (THGrouperConditionEditable*) self.editableObject;
    return [NSString stringWithFormat:@"%@ is %@ ",condition.obj2,condition.propertyName2];
}

-(void) updateButtonTexts{
    THGrouperConditionEditable * condition = (THGrouperConditionEditable*) self.editableObject;
    
    NSString * title = @"";
    
    if(condition.obj1){
        title = [NSString stringWithFormat:@"%@ (%@)",condition.obj1,condition.propertyName1];
        self.obj1Button.enabled = YES;
    } else{
        self.obj1Button.enabled = NO;
    }
    
    [self.obj1Button setTitle:title forState:UIControlStateNormal];
    
    if(condition.obj2){
        title = [NSString stringWithFormat:@"%@ (%@)",condition.obj2,condition.propertyName2];
        self.obj2Button.enabled = YES;
    }else{
        title = @"";
        self.obj2Button.enabled = NO;
    }
    
    [self.obj2Button setTitle:title forState:UIControlStateNormal];
}

-(TFConnectionLine*) createConnectionLineFor:(TFEditableObject*) object{
    
    TFConnectionLine * connection = [TFConnectionLine connectionLine];
    connection.obj1 = (TFEditableObject*)self.editableObject;
    connection.obj2 = object;
    connection.selected = YES;
    
    return connection;
}

-(void) addConnection:(TFConnectionLine*) connection{
    TFEditor * editor = (TFEditor*) [THDirector sharedDirector].currentLayer;
    [editor addConnectionLine:connection];
}

-(void) removeConnection:(TFConnectionLine*) connection{
    
    TFEditor * editor = (TFEditor*) [THDirector sharedDirector].currentLayer;
    [editor removeConnectionLine:connection];
}

-(void) selectionChanged{
    
    //[Editor sharedInstance].selectedConnections = self.selectedConnections;
    THGrouperConditionEditable * conditionEditable = (THGrouperConditionEditable*) self.editableObject;
    
    if(button1Down){
        connection1 = [self createConnectionLineFor:conditionEditable.obj1];
        [self addConnection:connection1];
    } else {
        [self removeConnection:connection1];
    }
    
    if(button2Down){
        connection2 = [self createConnectionLineFor:conditionEditable.obj2];
        [self addConnection:connection2];
    } else {
        [self removeConnection:connection2];
    }
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

- (IBAction)grouperTypeChanged:(id)sender {
    
    THGrouperConditionEditable * condition = (THGrouperConditionEditable*) self.editableObject;
    condition.type = self.grouperTypeControl.selectedSegmentIndex;
    [self updateLabelText];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setDescriptionLabel:nil];
    [self setObj1Button:nil];
    [self setObj2Button:nil];
    [self setGrouperTypeControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
