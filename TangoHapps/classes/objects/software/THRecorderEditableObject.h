//
//  THRecorderEditableObject.h
//  TangoHapps
//
//  Created by Guven Candogan on 27/01/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THViewEditableObject.h"

@interface THRecorderEditableObject : THViewEditableObject

-(void) start;
-(void) stop;
-(void) send;
-(void) appendData:(NSInteger) data;

@end
