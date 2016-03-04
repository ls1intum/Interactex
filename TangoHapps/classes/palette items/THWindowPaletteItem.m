//
//  THWindowPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THWindowPaletteItem.h"
#import "THWindowEditable.h"

@implementation THWindowPaletteItem

- (void)dropAt:(CGPoint)location {
    
    THWindowEditable * windowEditable = [[THWindowEditable alloc] init];
    [self handleObjectDropped:windowEditable atLocation:location];
}

@end
