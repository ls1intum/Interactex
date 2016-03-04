//
//  THModuloOperatorPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THModuloOperatorPaletteItem.h"
#import "THModuloOperatorEditable.h"

@implementation THModuloOperatorPaletteItem

- (void)dropAt:(CGPoint)location {
    
    THModuloOperatorEditable * moduloEditable = [[THModuloOperatorEditable alloc] init];
    [self handleObjectDropped:moduloEditable atLocation:location];
}

@end
