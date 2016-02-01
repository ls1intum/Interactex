//
//  THMultiplicationOperandPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 31/01/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THMultiplicationOperatorPaletteItem.h"
#import "THMultiplicationOperatorEditable.h"

@implementation THMultiplicationOperatorPaletteItem

- (void)dropAt:(CGPoint)location {
    
    THMultiplicationOperatorEditable * multiplicationOperator = [[THMultiplicationOperatorEditable alloc] init];
    [self handleObjectDropped:multiplicationOperator atLocation:location];
}


@end
