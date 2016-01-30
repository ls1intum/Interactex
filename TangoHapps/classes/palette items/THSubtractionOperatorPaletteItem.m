//
//  THSubtractionOperatorPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 29/01/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THSubtractionOperatorPaletteItem.h"
#import "THSubtractionOperator.h"

@implementation THSubtractionOperatorPaletteItem

- (void)dropAt:(CGPoint)location {
    
    THSubtractionOperator * subtractionOperator = [[THSubtractionOperator alloc] init];
    [self handleObjectDropped:subtractionOperator atLocation:location];
}


@end
