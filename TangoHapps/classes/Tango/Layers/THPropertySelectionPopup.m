/*
THPropertySelectionPopup.m
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
    
    return [NSString stringWithFormat:@"Properties (%@)",self.object];
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
    
    //background
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:kSelectionPopupsDefaultColor.r green:kSelectionPopupsDefaultColor.g blue:kSelectionPopupsDefaultColor.b alpha:0.5];
    bgColorView.layer.masksToBounds = YES;
    bgColorView.layer.cornerRadius = 5;
    cell.selectedBackgroundView = bgColorView;
    
    
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