//
//  THConditionEditableProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

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
