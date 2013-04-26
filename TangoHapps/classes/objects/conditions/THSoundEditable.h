//
//  THSoundEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 4/23/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THActionEditable.h"

@interface THSoundEditable : THActionEditable

-(void) play;
@property (nonatomic) NSString * fileName;

@end
