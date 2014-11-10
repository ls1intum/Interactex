/*
THInvokableProperties.m
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

#import "THMethodsPropertyController.h"
#import "TFMethod.h"
#import "TFEventActionPair.h"
#import "TFMethodInvokeAction.h"
#import "TFConnectionLine.h"
#import "TFEditableObject.h"

@implementation THMethodsPropertyController

@synthesize tableView;

+(id) properties{
    return [[[self class] alloc] init];
}

-(id) init{
    self = [ super init];
    if(self){
        CGRect frame = CGRectMake(0, 0, 250, 250);
        
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.view = [[UIView alloc] initWithFrame:frame];
        [self.view addSubview:self.tableView];
    }
    return self;
}

-(NSString *)title
{
    return @"Methods";
}

-(void) changeObjectHighlighting:(TFEditableObject*) object highlighted:(BOOL) highlighted{

    object.highlighted = highlighted;
    THProject * project = [THDirector sharedDirector].currentProject;
    NSArray * connections = [project invocationConnectionsFrom:object to: (TFEditableObject*)self.editableObject];
    
    for (TFConnectionLine * connection in connections) {
        connection.selected = highlighted;
    }
}

-(void) highlightOrDeHighlightForMethod:(TFMethod*) method highlighted:(BOOL) highlighted{
    /*
    TFProject * project = [TFDirector sharedDirector].currentProject;
    NSMutableArray * actions = [project actionsForTarget:(EditableObject*)target];
    for (TFEventActionPair * pair in actions) {
        TFMethodInvokeAction * action = (TFMethodInvokeAction*) pair.action;
        TFEditableObject * source = action.source;
        if([action.method.name isEqualToString:method.name]){
            if(source.highlighted != highlighted){
                [self changeObjectHighlighting:source highlighted:highlighted];
            }
        }
    }*/
}

-(void) dehighlightForMethod:(TFMethod*) method{
    
    [self highlightOrDeHighlightForMethod:method highlighted:NO];
}

-(void) highlightForMethod:(TFMethod*) method {

    [self highlightOrDeHighlightForMethod:method highlighted:YES];
}

-(void) dehighlightCurrentMethod{
    
    NSInteger idx = self.tableView.indexPathForSelectedRow.row;

    TFEditableObject * editable = (TFEditableObject*) self.editableObject;
    TFMethod * method = [editable.methods objectAtIndex:idx];
    [self dehighlightForMethod:method];
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger idx = indexPath.row;
    TFEditableObject * editable = (TFEditableObject*) self.editableObject;
    TFMethod * method = [editable.methods objectAtIndex:idx];
    
    [self dehighlightForMethod:method];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger idx = indexPath.row;
    TFEditableObject * editable = (TFEditableObject*) self.editableObject;
    TFMethod * method = [editable.methods objectAtIndex:idx];
    
    [self highlightForMethod:method];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kEditableObjectTableRowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    TFEditableObject * editable = (TFEditableObject*) self.editableObject;
    return editable.methods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger idx = indexPath.row;
    TFEditableObject * editable = (TFEditableObject*) self.editableObject;
    TFMethod * method = [editable.methods objectAtIndex:idx];
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    UILabel * label = cell.textLabel;
    label.font = [UIFont fontWithName:kEditableObjectTableFont size:kEditableObjectTableFontSize];
    label.text = method.description;
    
    THProject * project = [THDirector sharedDirector].currentProject;
    NSMutableArray * actions = [project actionsForTarget:editable];
    for (TFEventActionPair * pair in actions) {
        TFMethodInvokeAction * action = (TFMethodInvokeAction*) pair.action;
        if([action.method.name isEqualToString:method.name]){
            label.textColor = [UIColor blueColor];
            break;
        }
    }
    
    return cell;
}


-(void) reloadState{
    
    [self.tableView reloadData];
    
    CGRect tableFrame = self.tableView.frame;
    self.tableView.frame = CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, self.tableView.contentSize.height);
    
    CGRect frame = self.view.frame;
    self.view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.tableView.contentSize.height);
    
    [self.sizeDelegate properties:self didChangeSize:self.view.frame.size];
    
}

-(void) connectionMade:(NSNotification*) notification{
    TFConnectionLine * connection = notification.object;
    if(connection.obj2 == self.editableObject){
        [self.tableView reloadData];
    }
}

-(void) viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionMade:) name:kNotificationConnectionMade object:nil];
    [super viewWillAppear:animated];
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [self dehighlightCurrentMethod];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
