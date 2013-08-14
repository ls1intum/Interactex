//
//  THClotheObjectProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/21/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THClotheObjectProperties.h"
#import "THHardwareComponent.h"
#import "THHardwareComponentEditableObject.h"
#import "THElementPinEditable.h"
#import "THElementPin.h"

@implementation THClotheObjectProperties

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kEditableObjectTableRowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    THHardwareComponentEditableObject *clotheObject = (THHardwareComponentEditableObject*)self.editableObject;
    return clotheObject.pins.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    THHardwareComponentEditableObject *clotheObject = (THHardwareComponentEditableObject*)self.editableObject;
    
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    UILabel * label = cell.textLabel;
    label.font = [UIFont fontWithName:kEditableObjectTableFont size:kEditableObjectTableFontSize];
    NSInteger idx = indexPath.row;
    
    NSString * cellText;
    THElementPinEditable * pinEditable = [clotheObject.pins objectAtIndex:idx];
    cellText = [NSString stringWithFormat:@"%@",pinEditable.description];
    
    if(!pinEditable.connected){
        label.textColor = [UIColor redColor];
    }
    
    label.text = cellText;
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


-(NSString*) title{
    return @"Pins";
}

-(void) viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadState) name:kNotificationPinAttached object:nil];

}

-(void) viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadState) name:kNotificationPinAttached object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
