//
//  THActivityRecognitionPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 16/03/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THActivityRecognitionPaletteItem.h"
#import "THActivityRecognitionEditable.h"

@implementation THActivityRecognitionPaletteItem

- (void)dropAt:(CGPoint)location {
    THActivityRecognitionEditable * activityRecognition = [[THActivityRecognitionEditable alloc] init];
    [self handleObjectDropped:activityRecognition atLocation:location];
}

@end
