//
//  THContactBookPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 12/13/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THContactBookPaletteItem.h"
#import "THContactBookEditable.h"
#import "THiPhoneEditableObject.h"

@implementation THContactBookPaletteItem

- (BOOL)canBeDroppedAt:(CGPoint)location {
    THCustomProject * project = (THCustomProject*) [THDirector sharedDirector].currentProject;
    if([project.iPhone testPoint:location]){
        return YES;
    }
    return NO;
}

- (void)dropAt:(CGPoint)location {
    THContactBookEditable * contactBook = [[THContactBookEditable alloc] init];
    contactBook.position = location;
    
    CGPoint locationTransformed = [TFHelper ConvertToCocos2dView:location];
    contactBook.position = locationTransformed;
    
    THCustomProject * project = (THCustomProject*) [THDirector sharedDirector].currentProject;
    [project addiPhoneObject:contactBook];
}

@end
