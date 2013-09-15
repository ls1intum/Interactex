/*
 * TangoFramework
 *
 * Copyright (c) 2012 Juan Haladjian
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "THTriggerableProperties.h"
#import "TFEditableObject.h"
#import "TFAction.h"
#import "TFConnectionLine.h"
#import "TFMethodInvokeAction.h"
#import "TFEventActionPair.h"
#import "TFMethod.h"
#import "TFEvent.h"

@implementation THTriggerableProperties
@synthesize tableView;
@synthesize removeButton;

+(id) properties{
    return [[[self class] alloc] init];
}

-(id) init{
    self = [ super init];
    if(self){
        CGRect frame = CGRectMake(0, 0, 230, 310);
        self.view = [[UIView alloc] initWithFrame:frame];
        
        CGRect tableFrame = CGRectMake(0, 0, 230, 250);
        self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        
        CGRect labelFrame = CGRectMake(5, 260, 150, 30);
        self.connectionCountLabel = [[UILabel alloc] initWithFrame:labelFrame];
        self.connectionCountLabel.backgroundColor = [UIColor clearColor];
        self.connectionCountLabel.textColor = [UIColor whiteColor];
        self.connectionCountLabel.font = [UIFont systemFontOfSize:13];
        [self.view addSubview:self.connectionCountLabel];
        
        self.removeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.removeButton.frame = CGRectMake(90, 260, 110, 50);
        [self.removeButton setTitle:@"Hold to remove" forState:UIControlStateNormal];
        self.removeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.removeButton addTarget:self action:@selector(removeButtonDown:) forControlEvents:UIControlEventTouchDown];
        [self.removeButton addTarget:self action:@selector(removeButtonUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.removeButton addTarget:self action:@selector(removeButtonUp:) forControlEvents:UIControlEventTouchUpOutside];
        [self.view addSubview:self.removeButton];
        
    }
    return self;
}

-(NSString *)title
{
    return @"Events";
}

-(void) changeObjectHighlighting:(TFEditableObject*) object highlighted:(BOOL) highlighted{
    
    object.highlighted = highlighted;
    TFEditableObject * editable = (TFEditableObject*) self.editableObject;
    NSArray * connections = [editable connectionsToObject:object];
    for (TFConnectionLine * connection in connections) {
        connection.selected = highlighted;
    }
}

-(void) highlightOrDeHighlightForEvent:(TFEvent*) event highlighted:(BOOL) highlighted{
    THCustomProject * project = [THDirector sharedDirector].currentProject;
    NSMutableArray * actions = [project actionsForSource:(TFEditableObject*)self.editableObject];
    for (TFEventActionPair * pair in actions) {
        TFEvent * worldEvent = pair.event;
        TFEditableObject * targetObj = pair.action.target;
        if([worldEvent.name isEqualToString:event.name]){
            if(targetObj.highlighted != highlighted){
                [self changeObjectHighlighting:targetObj highlighted:highlighted];
            }
        }
    }
}

-(void) dehighlightForEvent:(TFEvent*) event{
    
    [self highlightOrDeHighlightForEvent:event highlighted:NO];
}

-(void) highlightForEvent:(TFEvent*) event {
    
    [self highlightOrDeHighlightForEvent:event highlighted:YES];
}

-(void) dehighlightCurrentEvent{
    
    NSInteger idx = self.tableView.indexPathForSelectedRow.row;
    TFEditableObject * editable = (TFEditableObject*) self.editableObject;
    TFEvent * event = [editable.events objectAtIndex:idx];
    [self dehighlightForEvent:event];
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger idx = indexPath.row;
    TFEditableObject * editable = (TFEditableObject*) self.editableObject;
    TFEvent * event = [editable.events objectAtIndex:idx];
    
    [self dehighlightForEvent:event];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger idx = indexPath.row;
    TFEditableObject * editable = (TFEditableObject*) self.editableObject;
    TFEvent * event = [editable.events objectAtIndex:idx];
    
    [self highlightForEvent:event];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kEditableObjectTableRowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TFEditableObject * editable = (TFEditableObject*) self.editableObject;
    return editable.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    UILabel * label = cell.textLabel;
    label.font = [UIFont fontWithName:kEditableObjectTableFont size:kEditableObjectTableFontSize];
    
    TFEditableObject * editable = (TFEditableObject*) self.editableObject;
    TFEvent * event = [editable.events objectAtIndex:indexPath.row];
    label.text = event.description;
    
    THCustomProject * project = [THDirector sharedDirector].currentProject;
    NSMutableArray * actions = [project actionsForSource:editable];
    for (TFEventActionPair * pair in actions) {
        if([pair.event.name isEqualToString:event.name]){
            label.textColor = [UIColor blueColor];
            break;
        }
    }
    
    return cell;
}

-(void)updateConnectionLabel {
    THCustomProject * project = [THDirector sharedDirector].currentProject;
    TFEditableObject * editable = (TFEditableObject*) self.editableObject;
    NSMutableArray * actions = [project actionsForSource:editable];
    self.connectionCountLabel.text = [NSString stringWithFormat:@"%d connections",actions.count];
}

-(void) reloadState{
    
    [self.tableView reloadData];
    [self updateConnectionLabel];
    
    
    CGRect tableFrame = self.tableView.frame;
    self.tableView.frame = CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, self.tableView.contentSize.height);
    
    CGPoint origin = self.removeButton.frame.origin;
    CGSize size = self.removeButton.frame.size;
    self.removeButton.frame = CGRectMake(origin.x, tableFrame.origin.y + self.tableView.frame.size.height + 10, size.width, size.height);
    
    CGPoint originLabel = self.connectionCountLabel.frame.origin;
    CGSize sizeLabel = self.connectionCountLabel.frame.size;
    self.connectionCountLabel.frame = CGRectMake(originLabel.x, tableFrame.origin.y + self.tableView.frame.size.height + 10, sizeLabel.width, sizeLabel.height);
    
    CGRect frame = self.view.frame;
    self.view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.tableView.contentSize.height + 10 + self.removeButton.frame.size.height);
    
    [self.sizeDelegate properties:self didChangeSize:self.view.frame.size];
}

-(void)removeButtonDown:(id)sender {

    TFEditableObject * editable = (TFEditableObject*) self.editableObject;
    NSArray * connections = editable.connections;
    for (TFConnectionLine * connection in connections) {
        TFEditableObject * object = connection.obj2;
        object.highlighted = YES;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStartRemovingConnections object:nil];
    /*
    TFEditor * editor = (TFEditor*) [TFDirector sharedDirector].currentLayer;
    editor.removeConnections = YES;*/
}

-(void) stopRemovingConnections{
    TFEditableObject * editable = (TFEditableObject*) self.editableObject;
    NSArray * connections = editable.connections;
    for (TFConnectionLine * connection in connections) {
        TFEditableObject * object = connection.obj2;
        object.highlighted = NO;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStopRemovingConnections object:nil];
}

-(void)removeButtonUp:(id)sender {
    [self stopRemovingConnections];
    
    /*
    TFEditor * editor = (TFEditor*) [TFDirector sharedDirector].currentLayer;
    editor.removeConnections = NO;*/
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
    [self dehighlightCurrentEvent];
    if(self.removeButton.isTouchInside){
        [self stopRemovingConnections];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNotificationCenter *c = [NSNotificationCenter defaultCenter];
    [c addObserver:self selector:@selector(reloadData) name:kNotificationActionAdded object:nil];
    [c addObserver:self selector:@selector(reloadData) name:kNotificationActionRemoved object:nil];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setRemoveButton:nil];
    [self setConnectionCountLabel:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
