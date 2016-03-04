//
//  THOrOperatorPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 04/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THOrOperatorPaletteItem.h"
#import "THOrOperatorEditable.h"

@implementation THOrOperatorPaletteItem

- (void)dropAt:(CGPoint)location {
    
    THOrOperatorEditable * orOperator = [[THOrOperatorEditable alloc] init];
    [self handleObjectDropped:orOperator atLocation:location];
}

@end
