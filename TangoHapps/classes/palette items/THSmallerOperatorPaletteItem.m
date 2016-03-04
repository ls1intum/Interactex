//
//  THSmallerOperatorPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THSmallerOperatorPaletteItem.h"
#import "THSmallerOperatorEditable.h"

@implementation THSmallerOperatorPaletteItem

- (void)dropAt:(CGPoint)location {
    
    THSmallerOperatorEditable * smallerOperator = [[THSmallerOperatorEditable alloc] init];
    [self handleObjectDropped:smallerOperator atLocation:location];
}

@end
