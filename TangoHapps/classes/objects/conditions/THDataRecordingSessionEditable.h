//
//  THDataRecordingSessionEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 01/07/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THProgrammingElementEditable.h"

@interface THDataRecordingSessionEditable : THProgrammingElementEditable
{
    
}

-(void) start;
-(void) stop;
-(void) addSample:(id) sample;

@property(nonatomic, readonly) BOOL started;
@property(nonatomic, strong) NSMutableArray * data;

@end
