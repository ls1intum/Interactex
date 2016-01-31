//
//  THSubtractionOperatorPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 29/01/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THSubtractionOperatorPaletteItem.h"
#import "THSubtractionOperatorEditable.h"

@implementation THSubtractionOperatorPaletteItem

- (void)dropAt:(CGPoint)location {
    
    THSubtractionOperatorEditable * subtractionOperator = [[THSubtractionOperatorEditable alloc] init];
    [self handleObjectDropped:subtractionOperator atLocation:location];
}


@end
