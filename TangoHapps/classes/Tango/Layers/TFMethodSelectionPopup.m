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


#import "TFMethodSelectionPopup.h"
#import "TFEditableObject.h"
#import "TFProperty.h"
#import "TFMethod.h"
#import "TFMethodInvokeAction.h"
#import "TFEvent.h"

@implementation TFMethodSelectionPopup

-(id) init{
    self = [super init];
    if(self){
        
        _acceptedEvents = [NSMutableArray array];
        _acceptedMethods = [NSMutableArray array];
        
    }
    return self;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(tableView == self.table1){
        return @"Events";
    } else {
        return @"Methods";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath * path1 = self.table1.indexPathForSelectedRow;
    NSIndexPath * path2 = self.table2.indexPathForSelectedRow;
    
    if(path1 != nil && path2 != nil){
        
        TFEvent * event = [_acceptedEvents objectAtIndex:path1.row];
        TFMethod * method = [_acceptedMethods objectAtIndex:path2.row];
        
        TFMethodInvokeAction * action = [[TFMethodInvokeAction alloc] initWithTarget:self.object2 method:method];
        action.firstParam = event.param1;
        action.source = self.object1;
        [self.delegate methodSelectionPopup:self didSelectAction:action forEvent:event];
                
        [popOverController dismissPopoverAnimated:YES];
    }
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMethodSelectionPopupRowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.table1){
        return _acceptedEvents.count;
    } else {
        return _acceptedMethods.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    UILabel * label = cell.textLabel;
    label.font = [UIFont fontWithName:@"Arial" size:13];
    NSInteger idx = indexPath.row;
    
    NSString * cellText;
    if(tableView == self.table1){
        TFEvent * event = [_acceptedEvents objectAtIndex:idx];
        cellText = [NSString stringWithFormat:@"%@",event];
    } else{
        TFMethod * method = [_acceptedMethods objectAtIndex:idx];
        cellText = method.description;
    }
    
    label.text = cellText;
    return cell;
}

-(void) selectEventsAndMethods{
    
    for (TFEvent * event in self.object1.events) {
        for (TFMethod * method in self.object2.methods) {
            if([event canTriggerMethod:method]){
                if(![_acceptedEvents containsObject:event]){
                    [_acceptedEvents addObject:event];
                }
                if(![_acceptedMethods containsObject:method]){
                    [_acceptedMethods addObject:method];
                }
            }
        }
    }
}

-(void) loadTables{
    
    CGRect frame = CGRectMake(0, 0, 200, 200);
    self.view = [[UIView alloc] initWithFrame:frame];
    
    CGRect frame1 = CGRectMake(0, 0, 200, 200);
    self.table1 = [[UITableView alloc] initWithFrame:frame1 style:UITableViewStylePlain];
    self.table1.delegate = self;
    self.table1.dataSource = self;
    self.table1.contentMode = UIViewContentModeLeft;
    
    CGRect frame2 = CGRectMake(200, 0, 200, 200);
    self.table2 = [[UITableView alloc] initWithFrame:frame2 style:UITableViewStylePlain];
    self.table2.delegate = self;
    self.table2.dataSource = self;
    self.table1.contentMode = UIViewContentModeRight;
    
    [self.view addSubview:self.table1];
    [self.view addSubview:self.table2];
    
    [self adaptSizeToContent];
}

-(void) present{
    
    [self selectEventsAndMethods];
    
    if(_acceptedEvents.count > 0){
        
        [self loadTables];
        
        //popover
        CGPoint position = self.object1.center;
        position = [TFHelper ConvertToCocos2dView:position];
        
        CGRect invokableRect = self.object1.boundingBox;
        float invokableWidth = invokableRect.size.width;
        float invokableHeight = invokableRect.size.height;
        
        CGRect rect = CGRectMake(position.x - invokableWidth/2, position.y - invokableHeight/2, invokableWidth, invokableHeight);
        
        UIView * view = [[CCDirector sharedDirector] openGLView];
        popOverController = [[UIPopoverController alloc] initWithContentViewController:self];
        
        [popOverController presentPopoverFromRect:rect inView:view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void) adaptSizeToContent{
    
    NSInteger maxItemCount = MAX(_acceptedEvents.count,_acceptedMethods.count);
    float contentHeight = maxItemCount * kMethodSelectionPopupRowHeight + kPopupHeaderHeight;
    self.contentSizeForViewInPopover = CGSizeMake(400, contentHeight);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
