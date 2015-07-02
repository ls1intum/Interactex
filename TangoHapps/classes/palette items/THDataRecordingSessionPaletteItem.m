//
//  THDataRecordingSessionPaletteItem.m
//  TangoHapps
//
//  Created by Juan Haladjian on 01/07/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THDataRecordingSessionPaletteItem.h"
#import "THDataRecordingSessionEditable.h"

@implementation THDataRecordingSessionPaletteItem

- (void)dropAt:(CGPoint)location {
    
    THDataRecordingSessionEditable * dataRecorder = [[THDataRecordingSessionEditable alloc] init];
    [self handleObjectDropped:dataRecorder atLocation:location];
}

@end
