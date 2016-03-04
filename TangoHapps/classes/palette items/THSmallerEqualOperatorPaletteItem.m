//
//  THSmallerEqualOperatorPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THSmallerEqualOperatorPaletteItem.h"
#import "THSmallerEqualOperatorEditable.h"

@implementation THSmallerEqualOperatorPaletteItem

- (void)dropAt:(CGPoint)location {
    
    THSmallerEqualOperatorEditable * smallerEqualOperator = [[THSmallerEqualOperatorEditable alloc] init];
    [self handleObjectDropped:smallerEqualOperator atLocation:location];
}

@end
