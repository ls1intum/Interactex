//
//  THDivisionOperandPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 31/01/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THDivisionOperatorPaletteItem.h"
#import "THDivisionOperatorEditable.h"

@implementation THDivisionOperatorPaletteItem

- (void)dropAt:(CGPoint)location {
    
    THDivisionOperatorEditable * divisionOperator = [[THDivisionOperatorEditable alloc] init];
    [self handleObjectDropped:divisionOperator atLocation:location];
}


@end
