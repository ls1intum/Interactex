//
//  THEqualOperatorPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THEqualOperatorPaletteItem.h"
#import "THEqualOperatorEditable.h"

@implementation THEqualOperatorPaletteItem

- (void)dropAt:(CGPoint)location {
    
    THEqualOperatorEditable * equalOperator = [[THEqualOperatorEditable alloc] init];
    [self handleObjectDropped:equalOperator atLocation:location];
}

@end
