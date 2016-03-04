//
//  THNotEqualOperatorPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THNotEqualOperatorPaletteItem.h"
#import "THNotEqualOperatorEditable.h"

@implementation THNotEqualOperatorPaletteItem

- (void)dropAt:(CGPoint)location {
    
    THNotEqualOperatorEditable * notEqualOperator = [[THNotEqualOperatorEditable alloc] init];
    [self handleObjectDropped:notEqualOperator atLocation:location];
}

@end
