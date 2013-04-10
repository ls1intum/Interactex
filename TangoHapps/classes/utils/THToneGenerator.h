//
//  THToneGenerator.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>

@interface THToneGenerator : NSObject
{
	AudioComponentInstance toneUnit;
}

-(void) play;
-(void) stop;

@property (nonatomic) double theta;
@property (nonatomic) float frequency;

@end
