//
//  THRecorder.h
//  TangoHapps
//
//  Created by Guven Candogan on 26/01/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THView.h"

@interface THRecorder : THView

@property (nonatomic) NSMutableArray* buffer;
-(void) appendData:(NSInteger) data;

@end