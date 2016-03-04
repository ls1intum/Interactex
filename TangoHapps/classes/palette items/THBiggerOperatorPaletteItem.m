//
//  THBiggerOperatorPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THBiggerOperatorPaletteItem.h"
#import "THBiggerOperatorEditable.h"

@implementation THBiggerOperatorPaletteItem

- (void)dropAt:(CGPoint)location {
    
    THBiggerOperatorEditable * biggerOperator = [[THBiggerOperatorEditable alloc] init];
    [self handleObjectDropped:biggerOperator atLocation:location];
}

@end
