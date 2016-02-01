//
//  THAdditionOperatorPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 31/01/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THAdditionOperatorPaletteItem.h"
#import "THAdditionOperatorEditable.h"

@implementation THAdditionOperatorPaletteItem

- (void)dropAt:(CGPoint)location {
    
    THAdditionOperatorEditable * additionOperator = [[THAdditionOperatorEditable alloc] init];
    [self handleObjectDropped:additionOperator atLocation:location];
}

@end
