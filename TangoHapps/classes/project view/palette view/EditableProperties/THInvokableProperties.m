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

#import "THInvokableProperties.h"
#import "TFMethod.h"
#import "TFEventActionPair.h"
#import "TFMethodInvokeAction.h"
#import "TFConnectionLine.h"
#import "TFEditableObject.h"

@implementation THInvokableProperties

@synthesize tableView;

+(id) properties{
    return [[[self class] alloc] init];
}

-(id) init{
    self = [ super init];
    if(self){
        CGRect frame = CGRectMake(0, 0, 230, 250);
        
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
    THCustomProject * project = [THDirector sharedDirector].currentProject;
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
    
    THCustomProject * project = [THDirector sharedDirector].currentProject;
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
