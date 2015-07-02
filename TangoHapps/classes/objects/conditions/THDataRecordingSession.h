//
//  THDataRecordingSession.h
//  TangoHapps
//
//  Created by Juan Haladjian on 01/07/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THProgrammingElement.h"

@interface THDataRecordingSession : THProgrammingElement
{
}

-(void) start;
-(void) stop;
-(void) addSample:(id) sample;

@property(nonatomic,readonly) BOOL started;
@property(nonatomic, strong) NSMutableArray * data;

@end
