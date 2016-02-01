//
//  THPeakDetectorPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 01/02/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THPeakDetectorPaletteItem.h"
#import "THPeakDetectorEditable.h"

@implementation THPeakDetectorPaletteItem


- (void)dropAt:(CGPoint)location {
    
    THPeakDetectorEditable * peakDetector = [[THPeakDetectorEditable alloc] init];
    [self handleObjectDropped:peakDetector atLocation:location];
}

@end
