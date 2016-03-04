//
//  THAndOperatorPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 04/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THAndOperatorPaletteItem.h"
#import "THAndOperatorEditable.h"

@implementation THAndOperatorPaletteItem

- (void)dropAt:(CGPoint)location {
    
    THAndOperatorEditable * andOperator = [[THAndOperatorEditable alloc] init];
    [self handleObjectDropped:andOperator atLocation:location];
}

@end
