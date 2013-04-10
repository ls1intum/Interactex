//
//  THMusicPlayerEditableObject.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/23/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THViewEditableObject.h"

@interface THMusicPlayerEditableObject : THViewEditableObject 


-(void) play;
-(void) stop;
-(void) next;

@property (nonatomic) float volume;

@property (nonatomic) BOOL showPlayButton;
@property (nonatomic) BOOL showNextButton;
@property (nonatomic) BOOL showPreviousButton;

@property (nonatomic) BOOL visibleDuringSimulation;

@end
