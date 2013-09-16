//
//  THPropertySelectionPopup.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THPropertySelectionPopup.h"
#import "TFEditableObject.h"
#import "TFProperty.h"
#import "THInvocationConnectionLine.h"

@implementation THPropertySelectionPopup

-(id) init{
    self = [super init];
    if(self){

         _matchingProperties = [NSMutableArray array];
        
    }
    return self;
}

#pragma mark - Table View Delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Properties";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFProperty * property = [self.object.simulableObject.properties objectAtIndex:indexPath.row];
    [self.delegate propertySelectionPopup:self didSelectProperty:property];
    
    [popOverController dismissPopoverAnimated:YES];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMethodSelectionPopupRowHeight;
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.object.simulableObject.properties.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    UILabel * label = cell.textLabel;
    label.font = [UIFont fontWithName:@"Arial" size:13];
    
    TFProperty * property = [self.object.simulableObject.properties objectAtIndex:indexPath.row];
    
    label.text = property.name;
    return cell;
}

#pragma mark - Methods

-(void) loadTables{
    
    CGRect frame = CGRectMake(0, 0, 200, 200);
    self.view = [[UIView alloc] initWithFrame:frame];
    
    CGRect frame1 = CGRectMake(0, 0, 200, 200);
    self.table = [[UITableView alloc] initWithFrame:frame1 style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.contentMode = UIViewContentModeLeft;
    
    [self.view addSubview:self.table];
    
    [self adaptSizeToContent];
}

-(void) selectEventsAndMethods{
    
    for (TFProperty * property in self.object.simulableObject.properties) {
        if([THClientHelper canConvertParam:property.type toType:self.connection.parameterType]){
            [_matchingProperties addObject:property];
        }
    }
}

-(void) present{
    
    [self selectEventsAndMethods];
    
    if(self.object.simulableObject.properties.count > 0){
        
        [self loadTables];
        
        //popover
        CGPoint position = self.object.center;
        position = [TFHelper ConvertToCocos2dView:position];
        
        CGRect invokableRect = self.object.boundingBox;
        float invokableWidth = invokableRect.size.width;
        float invokableHeight = invokableRect.size.height;
        
        CGRect rect = CGRectMake(position.x - invokableWidth/2, position.y - invokableHeight/2, invokableWidth, invokableHeight);
        
        UIView * view = [CCDirector sharedDirector].view;
        popOverController = [[UIPopoverController alloc] initWithContentViewController:self];
        
        [popOverController presentPopoverFromRect:rect inView:view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void) adaptSizeToContent{
    
    NSInteger itemCount = self.object.simulableObject.properties.count;
    float contentHeight = itemCount * kMethodSelectionPopupRowHeight + kPopupHeaderHeight;
    self.contentSizeForViewInPopover = CGSizeMake(200, contentHeight);
}

@end