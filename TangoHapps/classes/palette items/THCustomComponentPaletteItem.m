//
//  THCustomComponentPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 23/06/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THCustomComponentPaletteItem.h"
#import "THCustomComponentEditable.h"
#import "THCustomComponent.h"

@implementation THCustomComponentPaletteItem

- (void)dropAt:(CGPoint)location {
    THCustomComponent * customComponent = [[THDirector sharedDirector] softwareComponentWithName:self.name];
    THCustomComponentEditable * customComponentEditable = [[THCustomComponentEditable alloc] init];
    customComponentEditable.simulableObject = customComponent;
    if(customComponent != nil){
        [self handleObjectDropped:customComponentEditable atLocation:location];
    }
}

@end
