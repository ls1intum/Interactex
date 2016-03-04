//
//  THBiggerEqualOperatorPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THBiggerEqualOperatorPaletteItem.h"
#import "THBiggerEqualOperatorEditable.h"

@implementation THBiggerEqualOperatorPaletteItem

- (void)dropAt:(CGPoint)location {
    
    THBiggerEqualOperatorEditable * biggerEqualOperator = [[THBiggerEqualOperatorEditable alloc] init];
    [self handleObjectDropped:biggerEqualOperator atLocation:location];
}

@end
