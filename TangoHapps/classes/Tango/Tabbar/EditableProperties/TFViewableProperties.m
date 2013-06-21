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

#import "TFViewableProperties.h"
#import "TFProperty.h"
#import "TFConnectionLine.h"
#import "TFMethodInvokeAction.h"
#import "TFEditableObject.h"

@implementation TFViewableProperties
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

-(void) willDissappear{
    [self unselectAllConnections];
}

-(NSString *)title
{
    return @"Properties";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    TFEditableObject * editable = (TFEditableObject*) self.editableObject;
    return editable.viewableProperties.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFEditableObject * editable = (TFEditableObject*) self.editableObject;
    NSMutableArray * properties = editable.viewableProperties;
    NSInteger idx = indexPath.row;
    TFProperty * property = [properties objectAtIndex:idx];
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    UILabel * label = cell.textLabel;
    label.font = [UIFont fontWithName:@"Arial" size:13];
    label.text = property.description;
    
    return cell;
}

-(void) unselectAllConnections{
    
    TFEditableObject * editable = (TFEditableObject*) self.editableObject;
    NSMutableArray * connections = editable.connections;
    for (TFConnectionLine * connection in connections) {
        connection.selected = NO;
    }
}

-(BOOL) doesActionArray:(NSArray*) array containObject:(id) object{
    for (TFMethodInvokeAction * action in array) {
        if(action.target == object){
            return YES;
        }
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[self selectionChanged];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[self selectionChanged];
}

-(void) reloadState{
    
    [self.tableView reloadData];
    
    
    CGRect tableFrame = self.tableView.frame;
    self.tableView.frame = CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, self.tableView.contentSize.height);
    
    CGRect frame = self.view.frame;
    self.view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.tableView.contentSize.height);
    
    [self.sizeDelegate properties:self didChangeSize:self.view.frame.size];
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
